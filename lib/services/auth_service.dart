import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get userStream => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// ============================
  /// Login Email
  /// ============================
  Future<String> login(
    String email,
    String password,
  ) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = result.user;

    if (user == null) {
      throw Exception("ไม่พบผู้ใช้งาน");
    }

    final doc = await _firestore.collection("users").doc(user.uid).get();

    if (!doc.exists) {
      throw Exception("ไม่พบข้อมูลผู้ใช้");
    }

    await _firestore.collection("users").doc(user.uid).update({
      "lastLogin": FieldValue.serverTimestamp(),
    });

    return doc.data()?["role"] ?? "user";
  }

  /// ============================
  /// Register
  /// ============================
  Future<User?> register(
    String name,
    String email,
    String password,
  ) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = result.user;

    if (user != null) {
      await _saveUser(user, name);
    }

    return user;
  }

  /// ============================
  /// Google Login
  /// ============================
  Future<String> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize();

    final GoogleSignInAccount account = await googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth = account.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(
      credential,
    );

    final user = result.user;

    if (user == null) {
      throw Exception("Google Login ไม่สำเร็จ");
    }

    final userRef = _firestore.collection("users").doc(user.uid);

    final doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        "uid": user.uid,
        "name": user.displayName ?? "",
        "email": user.email ?? "",
        "photoUrl": user.photoURL ?? "",
        "role": "user",
        "createdAt": FieldValue.serverTimestamp(),
        "lastLogin": FieldValue.serverTimestamp(),
      });

      return "user";
    }

    await userRef.update({
      "name": user.displayName ?? "",
      "email": user.email ?? "",
      "photoUrl": user.photoURL ?? "",
      "lastLogin": FieldValue.serverTimestamp(),
    });

    return doc.data()?["role"] ?? "user";
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
  /// Save User
  /// ============================
  Future<void> _saveUser(
    User user,
    String name,
  ) async {
    await _firestore.collection("users").doc(user.uid).set(
      {
        "uid": user.uid,
        "name": name,
        "email": user.email ?? "",
        "photoUrl": user.photoURL ?? "",
        "role": "user",
        "createdAt": FieldValue.serverTimestamp(),
        "lastLogin": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
