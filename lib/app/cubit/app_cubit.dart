import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        super(AppState.initial()) {
    _authSubscription = _firebaseAuth
        .authStateChanges()
        .listen((user) => _onFirebaseUserChanged(user));
    _onFirebaseUserChanged(_firebaseAuth.currentUser);
  }

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  StreamSubscription<User?>? _authSubscription;

  Future<void> _onFirebaseUserChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      emit(
        state.copyWith(
          status: AppStatus.unauthenticated,
          clearUser: true,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AppStatus.initializing,
        clearError: true,
      ),
    );

    try {
      final appUser = await _fetchUser(firebaseUser.uid);
      emit(
        state.copyWith(
          status: AppStatus.authenticated,
          user: appUser,
          clearError: true,
        ),
      );
    } on FirebaseAuthException catch (error) {
      emit(
        state.copyWith(
          status: AppStatus.failure,
          errorMessage: error.message,
        ),
      );
    } on FirebaseException catch (error) {
      emit(
        state.copyWith(
          status: AppStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AppStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<AppUser> _fetchUser(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();

    if (data == null) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        message: 'User profile not found for id: $uid',
      );
    }

    final createdAt = data['createdAt'];
    final createdAtDate = createdAt is Timestamp
        ? createdAt.toDate()
        : createdAt is DateTime
            ? createdAt
            : createdAt is String && createdAt.isNotEmpty
                ? DateTime.tryParse(createdAt)
                : null;

    return AppUser.fromJson({
      'id': snapshot.id,
      ...data,
      if (createdAtDate != null) 'createdAt': createdAtDate,
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    emit(
      state.copyWith(
        status: AppStatus.unauthenticated,
        clearUser: true,
        clearError: true,
      ),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
