import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current User

  User? get currentUser => _auth.currentUser;

  // ==========================
  // Register Email Password
  // ==========================

  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User user = result.user!;

    await _firestore.collection("users").doc(user.uid).set({
      "name": name,
      "email": email,
      "role": "user",
      "createdAt": FieldValue.serverTimestamp(),
    });

    return user;
  }

  // ==========================
  // Login Email Password
  // ==========================

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

  // ==========================
  // Google Login
  // ==========================

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(
        credential,
      );

      User user = result.user!;

      // ตรวจสอบ Firestore User

      DocumentSnapshot doc =
          await _firestore.collection("users").doc(user.uid).get();

      // ถ้า User ใหม่ ให้สร้างข้อมูล

      if (!doc.exists) {
        await _firestore.collection("users").doc(user.uid).set({
          "name": user.displayName ?? "",
          "email": user.email ?? "",
          "role": "user",
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      throw Exception(
        "Google Login Failed : $e",
      );
    }
  }

  // ==========================
  // Get User Role
  // ==========================

  Future<String> getUserRole(String uid) async {
    DocumentSnapshot doc = await _firestore.collection("users").doc(uid).get();

    if (doc.exists) {
      return doc["role"];
    }

    return "user";
  }

  // ==========================
  // Logout
  // ==========================

  Future<void> logout() async {
    await _auth.signOut();
  }
}
