import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // ➕ เพิ่มอุปกรณ์
  Future<void> addDevice() async {
    await db.collection("devices").add({
      "name": "Fan",
      "type": "fan",
      "status": true,
      "powerUsage": 50,
      "room": "bedroom",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // 👀 อ่านข้อมูลแบบ real-time
  Stream<QuerySnapshot> getDevices() {
    return db.collection("devices").snapshots();
  }
}
