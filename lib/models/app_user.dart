import 'dart:convert';

import 'package:crypto/crypto.dart';

class AppUser {
  const AppUser({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.createdAt,
  });

  final int? id;
  final String name;
  final String email;
  final String passwordHash;
  final DateTime? createdAt;

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email.toLowerCase(),
      'password_hash': passwordHash,
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, Object?> map) {
    return AppUser(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      passwordHash: map['password_hash'] as String? ?? '',
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? ''),
    );
  }
}
