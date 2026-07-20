import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _googleSignInInitialized = false;

  static const String _serverClientId =
      '1067405232898-l2auji1mtvp383dsq12793kmfjvt97ad.apps.googleusercontent.com';

  // ==========================
  // Current User
  // ==========================

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool get isLoggedIn => _auth.currentUser != null;

  // ==========================
  // Register Email Password
  // ==========================

  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = result.user;

      if (user == null) {
        throw Exception('ไม่สามารถสร้างบัญชีผู้ใช้ได้');
      }

      await user.updateDisplayName(name.trim());

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name.trim(),
        'email': email.trim(),
        'photoUrl': user.photoURL,
        'role': 'user',
        'loginProvider': 'email',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return user;
    } on FirebaseAuthException catch (error) {
      throw Exception(
        _getFirebaseAuthErrorMessage(error),
      );
    } on FirebaseException catch (error) {
      throw Exception(
        'บันทึกข้อมูลผู้ใช้ไม่สำเร็จ: '
        '${error.message ?? error.code}',
      );
    } catch (error) {
      throw Exception(
        'สมัครสมาชิกไม่สำเร็จ: $error',
      );
    }
  }

  // ==========================
  // Login Email Password
  // ==========================

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = result.user;

      if (user == null) {
        throw Exception('ไม่พบข้อมูลผู้ใช้');
      }

      await _updateLastLogin(user);

      return user;
    } on FirebaseAuthException catch (error) {
      throw Exception(
        _getFirebaseAuthErrorMessage(error),
      );
    } catch (error) {
      throw Exception(
        'เข้าสู่ระบบไม่สำเร็จ: $error',
      );
    }
  }

  // ==========================
  // Initialize Google Sign-In
  // ==========================

  Future<void> _initializeGoogleSignIn() async {
    if (_googleSignInInitialized) {
      return;
    }

    await _googleSignIn.initialize(
      serverClientId: _serverClientId,
    );

    _googleSignInInitialized = true;
  }

  // ==========================
  // Google Login
  // ==========================

  Future<User?> signInWithGoogle() async {
    try {
      await _initializeGoogleSignIn();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception(
          'Google Sign-In ไม่ส่ง ID Token กลับมา',
        );
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(
        credential,
      );

      final User? user = result.user;

      if (user == null) {
        throw Exception(
          'ไม่พบข้อมูลผู้ใช้หลังเข้าสู่ระบบด้วย Google',
        );
      }

      final DocumentReference<Map<String, dynamic>> userReference =
          _firestore.collection('users').doc(user.uid);

      final DocumentSnapshot<Map<String, dynamic>> userDocument =
          await userReference.get();

      if (!userDocument.exists) {
        await userReference.set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'photoUrl': user.photoURL,
          'role': 'user',
          'loginProvider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      } else {
        await userReference.set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'photoUrl': user.photoURL,
          'loginProvider': 'google',
          'updatedAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return user;
    } on GoogleSignInException catch (error) {
      throw Exception(
        'Google Login Failed: '
        '${error.code} '
        '${error.description ?? ''}',
      );
    } on FirebaseAuthException catch (error) {
      throw Exception(
        _getFirebaseAuthErrorMessage(error),
      );
    } on FirebaseException catch (error) {
      throw Exception(
        'Firestore Failed: '
        '${error.code} '
        '${error.message ?? ''}',
      );
    } catch (error) {
      throw Exception(
        'Google Login Failed: $error',
      );
    }
  }

  // ==========================
  // Get User Role
  // ==========================

  Future<String> getUserRole(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> document =
          await _firestore.collection('users').doc(uid).get();

      final Map<String, dynamic>? data = document.data();

      return data?['role'] as String? ?? 'user';
    } on FirebaseException catch (error) {
      throw Exception(
        'อ่านสิทธิ์ผู้ใช้ไม่สำเร็จ: '
        '${error.message ?? error.code}',
      );
    }
  }

  // ==========================
  // Send Password Reset Email
  // ==========================

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (error) {
      throw Exception(
        _getFirebaseAuthErrorMessage(error),
      );
    }
  }

  // ==========================
  // Logout
  // ==========================

  Future<void> logout() async {
    try {
      await _auth.signOut();

      await _initializeGoogleSignIn();
      await _googleSignIn.signOut();
    } catch (error) {
      throw Exception(
        'ออกจากระบบไม่สำเร็จ: $error',
      );
    }
  }

  // ==========================
  // Update Last Login
  // ==========================

  Future<void> _updateLastLogin(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'photoUrl': user.photoURL,
      'updatedAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ==========================
  // Firebase Error Messages
  // ==========================

  String _getFirebaseAuthErrorMessage(
    FirebaseAuthException error,
  ) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'อีเมลนี้ถูกใช้งานแล้ว';

      case 'invalid-email':
        return 'รูปแบบอีเมลไม่ถูกต้อง';

      case 'weak-password':
        return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';

      case 'user-not-found':
        return 'ไม่พบบัญชีผู้ใช้นี้';

      case 'wrong-password':
      case 'invalid-credential':
        return 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';

      case 'user-disabled':
        return 'บัญชีผู้ใช้นี้ถูกระงับ';

      case 'too-many-requests':
        return 'มีการพยายามเข้าสู่ระบบหลายครั้ง กรุณารอสักครู่';

      case 'network-request-failed':
        return 'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้';

      case 'account-exists-with-different-credential':
        return 'อีเมลนี้เคยสมัครด้วยวิธีเข้าสู่ระบบแบบอื่น';

      default:
        return error.message ?? 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
    }
  }
}
