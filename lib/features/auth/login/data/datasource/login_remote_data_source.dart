import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/shared.dart';

abstract interface class LoginRemoteDataSource {
  Future<User> login({required String email, required String password});

  Future<AppUser> getUser({required String id});
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  const LoginRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<AppUser> getUser({required String id}) async {
    final snapshot = await firestore.collection('users').doc(id).get();
    final data = snapshot.data();

    if (data == null) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        message: 'User not found for id: $id',
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

  @override
  Future<User> login({required String email, required String password}) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user returned from sign-in.',
      );
    }

    return user;
  }
}
