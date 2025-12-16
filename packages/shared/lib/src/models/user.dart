// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';

/// {@template user}
/// Model representing an authenticated user.
/// {@endtemplate}
@immutable
class AppUser {
  /// {@macro user}
  const AppUser({
    required this.id,
    this.name,
    this.email,
    this.role = UserRole.student,
    this.studentNumber,
    this.staffNumber,
    this.createdAt,
  });

  /// Creates a user from a JSON map.
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: UserRoleX.fromString(json['role'] as String?) ?? UserRole.student,
      studentNumber: json['studentNumber'] as String?,
      staffNumber: json['staffNumber'] as String?,
      createdAt: _dateFromJson(json['createdAt']),
    );
  }

  /// An empty user instance to represent unauthenticated state.
  static const empty = AppUser(id: '');

  /// Unique identifier for the user.
  final String id;

  /// User display name.
  final String? name;

  /// User email address.
  final String? email;

  /// Role assigned to the user.
  final UserRole role;

  /// Student number (for students).
  final String? studentNumber;

  /// Staff number (for lecturers/admins).
  final String? staffNumber;

  /// Account creation timestamp.
  final DateTime? createdAt;

  /// Whether this user is the empty instance.
  bool get isEmpty => this == AppUser.empty;

  /// Whether this user is not the empty instance.
  bool get isNotEmpty => this != AppUser.empty;

  /// Creates a new instance with updated fields.
  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? studentNumber,
    String? staffNumber,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      studentNumber: studentNumber ?? this.studentNumber,
      staffNumber: staffNumber ?? this.staffNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Converts the user to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role.name,
        'studentNumber': studentNumber,
        'staffNumber': staffNumber,
        'createdAt': createdAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AppUser) return false;
    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.studentNumber == studentNumber &&
        other.staffNumber == staffNumber &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, name, email, role, studentNumber, staffNumber, createdAt);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role, '
        'studentNumber: $studentNumber, staffNumber: $staffNumber, '
        'createdAt: $createdAt)';
  }

  static DateTime? _dateFromJson(Object? value) {
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}

/// Available user roles.
enum UserRole { admin, lecturer, student }

extension UserRoleX on UserRole {
  static UserRole? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'lecturer':
        return UserRole.lecturer;
      case 'student':
        return UserRole.student;
      default:
        return null;
    }
  }
}
