import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _loading = true;

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
  /// Login ด้วย Email
  /// ============================
  Future<void> login(
    String email,
    String password,
  ) async {
    _loading = true;
    notifyListeners();

    try {
      await _authService.login(email, password);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ============================
  /// สมัครสมาชิก
  /// ============================
  Future<void> register(
    String email,
    String password,
  ) async {
    _loading = true;
    notifyListeners();

    try {
      await _authService.register(email, password);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ============================
  /// Login ด้วย Google
  /// ============================
  Future<void> signInWithGoogle() async {
    _loading = true;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
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

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
