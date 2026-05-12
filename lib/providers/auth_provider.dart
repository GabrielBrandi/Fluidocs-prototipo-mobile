import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/app_database.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  bool _isAuthenticated = false;
  AppUser? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  AppUser? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    final user = await _database.authenticateUser(
      email: email,
      password: password,
    );

    if (user == null) return false;

    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final existingUser = await _database.findUserByEmail(email);
    if (existingUser != null) {
      return 'Este email já está cadastrado.';
    }

    await _database.insertUser(name: name, email: email, password: password);
    return null;
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
