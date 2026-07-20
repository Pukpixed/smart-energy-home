import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  /// เพิ่มข้อมูลโดยให้ Firestore สร้าง Document ID อัตโนมัติ
  Future<String?> addData({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      final document = await _firestore.collection(collection).add(data);

      return document.id;
    } on FirebaseException catch (error) {
      debugPrint(
        'Firebase addData error: ${error.code} - ${error.message}',
      );

      return null;
    } catch (error) {
      debugPrint('addData error: $error');

      return null;
    }
  }

  /// เพิ่มหรือเขียนข้อมูลโดยกำหนด Document ID เอง
  Future<bool> setData({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).set(
            data,
            SetOptions(merge: merge),
          );

      return true;
    } on FirebaseException catch (error) {
      debugPrint(
        'Firebase setData error: ${error.code} - ${error.message}',
      );

      return false;
    } catch (error) {
      debugPrint('setData error: $error');

      return false;
    }
  }

  /// อ่านข้อมูลทั้งหมดจาก Collection แบบครั้งเดียว
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData(
    String collection,
  ) async {
    try {
      final snapshot = await _firestore.collection(collection).get();

      return snapshot.docs;
    } on FirebaseException catch (error) {
      debugPrint(
        'Firebase getData error: ${error.code} - ${error.message}',
      );

      return [];
    } catch (error) {
      debugPrint('getData error: $error');

      return [];
    }
  }

  /// อ่านข้อมูล Document เดียว
  Future<DocumentSnapshot<Map<String, dynamic>>?> getDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      return await _firestore.collection(collection).doc(documentId).get();
    } on FirebaseException catch (error) {
      debugPrint(
        'Firebase getDocument error: ${error.code} - ${error.message}',
      );

      return null;
    } catch (error) {
      debugPrint('getDocument error: $error');

      return null;
    }
  }

  /// รับข้อมูลทั้งหมดจาก Collection แบบเรียลไทม์
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
    String collection,
  ) {
    return _firestore.collection(collection).snapshots();
  }

  /// รับข้อมูล Document เดียวแบบเรียลไทม์
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument({
    required String collection,
    required String documentId,
  }) {
    return _firestore.collection(collection).doc(documentId).snapshots();
  }

  /// แก้ไขข้อมูลใน Document
  Future<bool> updateData({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).update(data);

      return true;
    } on FirebaseException catch (error) {
      debugPrint(
        'Firebase updateData error: ${error.code} - ${error.message}',
      );

      return false;
    } catch (error) {
      debugPrint('updateData error: $error');

      return false;
    }
  }

  /// ลบ Document
  Future<bool> deleteData({
    required String collection,
    required String documentId,
  }) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();

      return true;
    } on FirebaseException catch (error) {
      debugPrint(
        'Firebase deleteData error: ${error.code} - ${error.message}',
      );

      return false;
    } catch (error) {
      debugPrint('deleteData error: $error');

      return false;
    }
  }
}
