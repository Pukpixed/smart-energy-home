import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreSeedService {
  FirestoreSeedService._();

  static final FirestoreSeedService instance = FirestoreSeedService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createInitialData() async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception(
        'กรุณาเข้าสู่ระบบก่อนสร้างข้อมูลเริ่มต้น',
      );
    }

    final String uid = currentUser.uid;
    final WriteBatch batch = _firestore.batch();

    // users
    final userRef = _firestore.collection('users').doc(uid);

    batch.set(
      userRef,
      {
        'uid': uid,
        'name': currentUser.displayName ?? 'ผู้ใช้งาน',
        'email': currentUser.email ?? '',
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // devices
    final airRef =
        _firestore.collection('devices').doc('${uid}_air_conditioner_01');

    batch.set(
      airRef,
      {
        'userId': uid,
        'name': 'เครื่องปรับอากาศ',
        'type': 'ac',
        'room': 'ห้องนอน',
        'status': true,
        'power': 1200.0,
        'mqttTopic': 'smart_home/device/air_conditioner_01/control',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    final tvRef = _firestore.collection('devices').doc('${uid}_television_01');

    batch.set(
      tvRef,
      {
        'userId': uid,
        'name': 'โทรทัศน์',
        'type': 'tv',
        'room': 'ห้องนั่งเล่น',
        'status': true,
        'power': 150.0,
        'mqttTopic': 'smart_home/device/television_01/control',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    final lightRef = _firestore.collection('devices').doc('${uid}_light_01');

    batch.set(
      lightRef,
      {
        'userId': uid,
        'name': 'หลอดไฟ',
        'type': 'light',
        'room': 'ห้องครัว',
        'status': false,
        'power': 12.0,
        'mqttTopic': 'smart_home/device/light_01/control',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // energy_logs
    final energyRef =
        _firestore.collection('energy_logs').doc('${uid}_initial_energy');

    batch.set(
      energyRef,
      {
        'userId': uid,
        'deviceId': 'device01',
        'voltage': 220.0,
        'current': 1.25,
        'power': 275.0,
        'energy': 12.45,
        'cost': 52.29,
        'timestamp': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // notifications
    final notificationRef =
        _firestore.collection('notifications').doc('${uid}_welcome');

    batch.set(
      notificationRef,
      {
        'userId': uid,
        'title': 'เริ่มต้นใช้งานระบบ',
        'message': 'ระบบ Smart Energy Home พร้อมใช้งานแล้ว',
        'type': 'system',
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // reports
    final reportRef =
        _firestore.collection('reports').doc('${uid}_initial_report');

    batch.set(
      reportRef,
      {
        'userId': uid,
        'reportType': 'daily',
        'totalEnergy': 12.45,
        'totalCost': 52.29,
        'date': Timestamp.now(),
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // automation_rules
    final automationRef = _firestore
        .collection('automation_rules')
        .doc('${uid}_power_limit_rule');

    batch.set(
      automationRef,
      {
        'userId': uid,
        'name': 'ปิดอุปกรณ์เมื่อใช้ไฟเกินกำหนด',
        'deviceId': '${uid}_air_conditioner_01',
        'conditionType': 'power_greater_than',
        'conditionValue': 1500.0,
        'action': 'turn_off',
        'isEnabled': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // settings
    final settingsRef = _firestore.collection('settings').doc(uid);

    batch.set(
      settingsRef,
      {
        'userId': uid,
        'electricityRate': 4.2,
        'notificationEnabled': true,
        'energyAlertLimit': 15.0,
        'language': 'th',
        'theme': 'dark',
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // admin
    final adminRef = _firestore.collection('admin').doc('system_config');

    batch.set(
      adminRef,
      {
        'appName': 'Smart Energy Home',
        'projectId': 'smart-energy-home-app',
        'systemStatus': 'active',
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }
}
