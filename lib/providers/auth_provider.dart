import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool loading = false;

  // ==========================
  // Current User
  // ==========================

  User? get user => _service.currentUser;

  bool get isLoggedIn => _service.currentUser != null;

  // ==========================
  // Register
  // ==========================

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      loading = true;
      notifyListeners();

      await _service.register(
        name: name,
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ==========================
  // Login
  // ==========================

  Future<String> login({
    required String email,
    required String password,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final user = await _service.login(
        email: email,
        password: password,
      );

      final role = await _service.getUserRole(
        user!.uid,
      );

      notifyListeners();

      return role;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ==========================
  // Google Login
  // ==========================

  Future<String> signInWithGoogle() async {
    loading = true;
    notifyListeners();

    try {
      final user = await _service.signInWithGoogle();

      if (user == null) {
        throw Exception(
          "ยกเลิก Google Login",
        );
      }

      final role = await _service.getUserRole(
        user.uid,
      );

      notifyListeners();

      return role;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ==========================
  // Logout
  // ==========================

  Future<void> logout() async {
    await _service.logout();

    notifyListeners();
  }
}
