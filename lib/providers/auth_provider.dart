import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _loading = false;

  User? get user => _user;
  bool get loading => _loading;
  String? get uid => _user?.uid;

  late final StreamSubscription<User?> _authSubscription;

  AuthProvider() {
    _user = _authService.currentUser;

    _authSubscription = _authService.userStream.listen((user) {
      _user = user;
      _loading = false;
      notifyListeners();
    });
  }

  /// ============================
  /// Login
  /// ============================
  Future<String> login(
    String email,
    String password,
  ) async {
    _loading = true;
    notifyListeners();

    try {
      return await _authService.login(
        email,
        password,
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ============================
  /// Register
  /// ============================
  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    _loading = true;
    notifyListeners();

    try {
      await _authService.register(
        name,
        email,
        password,
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ============================
  /// Login Google
  /// ============================
  Future<String> signInWithGoogle() async {
    _loading = true;
    notifyListeners();

    try {
      return await _authService.signInWithGoogle();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ============================
  /// Logout
  /// ============================
  Future<void> logout() async {
    _loading = true;
    notifyListeners();

    try {
      await _authService.logout();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ============================
  /// Refresh User
  /// ============================
  Future<void> reloadUser() async {
    await _user?.reload();
    _user = _authService.currentUser;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
