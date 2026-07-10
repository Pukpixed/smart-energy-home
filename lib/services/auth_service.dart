import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get userStream => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// ============================
  /// Login ด้วย Email
  /// ============================
  Future<User?> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    return result.user;
  }

  /// ============================
  /// สมัครสมาชิก
  /// ============================
  Future<User?> register(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = result.user;

    if (user != null) {
      await _saveUser(user);
    }

    return user;
  }

  /// ============================
  /// Login ด้วย Google
  /// ============================
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount account = await googleSignIn.authenticate();

      final GoogleSignInAuthentication auth = account.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      final user = result.user;

      if (user != null) {
        await _saveUser(user);
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// ============================
  /// Logout
  /// ============================
  Future<void> logout() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}

    await _auth.signOut();
  }

  /// ============================
  /// บันทึกข้อมูลผู้ใช้
  /// ============================
  Future<void> _saveUser(User user) async {
    await _firestore.collection('users').doc(user.uid).set(
      {
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoUrl': user.photoURL ?? '',
        'lastLogin': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
