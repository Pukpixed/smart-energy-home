import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/device_model.dart';

class DeviceProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DeviceModel> _devices = [];

  List<DeviceModel> get devices => _devices;

  /// โหลดข้อมูลอุปกรณ์ทั้งหมด
  Future<void> fetchDevices() async {
    try {
      final snapshot = await _firestore.collection('devices').get();

      _devices =
          snapshot.docs.map((doc) => DeviceModel.fromMap(doc.data())).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Fetch Devices Error : $e");
    }
  }

  /// เปลี่ยนสถานะเปิด/ปิดอุปกรณ์
  Future<void> toggleDevice(DeviceModel device) async {
    try {
      await _firestore.collection('devices').doc(device.id).update({
        'status': !device.status,
      });

      await fetchDevices();
    } catch (e) {
      debugPrint("Toggle Device Error : $e");
    }
  }

  /// เพิ่มอุปกรณ์
  Future<void> addDevice(DeviceModel device) async {
    try {
      await _firestore.collection('devices').doc(device.id).set(device.toMap());

      fetchDevices();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// ลบอุปกรณ์
  Future<void> deleteDevice(String id) async {
    try {
      await _firestore.collection('devices').doc(id).delete();

      fetchDevices();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
