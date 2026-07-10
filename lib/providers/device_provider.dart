import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/device_model.dart';

class DeviceProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DeviceModel> _devices = [];

  List<DeviceModel> get devices => _devices;

  void listenDevices(String uid) {
    _firestore
        .collection('devices')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      _devices = snapshot.docs
          .map(
            (doc) => DeviceModel.fromMap(
              doc.id,
              doc.data(),
            ),
          )
          .toList();

      notifyListeners();
    });
  }

  Future<void> toggleDevice(
    String deviceId,
    bool status,
  ) async {
    await _firestore.collection('devices').doc(deviceId).update({
      'status': status,
    });
  }
}
