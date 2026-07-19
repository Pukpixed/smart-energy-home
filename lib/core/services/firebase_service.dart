import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // เพิ่มข้อมูล

  Future<void> addData({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    await firestore.collection(collection).add(data);
  }

  // อ่านข้อมูล

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData(
      String collection) async {
    final snapshot = await firestore.collection(collection).get();

    return snapshot.docs;
  }

  // Realtime Stream

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
      String collection) {
    return firestore.collection(collection).snapshots();
  }

  // แก้ไขข้อมูล

  Future<void> updateData({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await firestore.collection(collection).doc(documentId).update(data);
  }

  // ลบข้อมูล

  Future<void> deleteData({
    required String collection,
    required String documentId,
  }) async {
    await firestore.collection(collection).doc(documentId).delete();
  }
}
