import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared/shared.dart';

abstract interface class RegisterRemoteDataSource {
  Future<User> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<bool> isStaffStudentIDExits({required String staffStudentID});

  Future<AppUser> createUserRecord({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? studentID,
    String? staffID,
  });
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const RegisterRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  @override
  Future<AppUser> createUserRecord({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? studentID,
    String? staffID,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Cannot create user record without an authenticated user.',
      );
    }

    final data = <String, dynamic>{
      'name': fullName,
      'email': email,
      'role': role,
      'studentNumber': studentID,
      'staffNumber': staffID,
      'createdAt': FieldValue.serverTimestamp(),
    }..removeWhere(
        (key, value) => value == null || (value is String && value.isEmpty),
      );

    await firestore.collection('users').doc(user.uid).set(data);

    return AppUser(
      id: user.uid,
      name: fullName,
      email: email,
      role: UserRoleX.fromString(role) ?? UserRole.student,
      studentNumber: studentID,
      staffNumber: staffID,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<bool> isStaffStudentIDExits({
    required String staffStudentID,
  }) async {
    final usersCollection = firestore.collection('users');
    final results = await Future.wait([
      usersCollection
          .where('studentNumber', isEqualTo: staffStudentID)
          .limit(1)
          .get(),
      usersCollection
          .where('staffNumber', isEqualTo: staffStudentID)
          .limit(1)
          .get(),
    ]);

    return results.any((snapshot) => snapshot.docs.isNotEmpty);
  }

  @override
  Future<User> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-creation-failed',
        message: 'No user returned after registration.',
      );
    }

    return user;
  }
}
