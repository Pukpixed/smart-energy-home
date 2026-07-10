import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getDevices() {
    return _firestore.collection('devices').snapshots();
  }

  Stream<QuerySnapshot> getEnergyLogs() {
    return _firestore.collection('energy_logs').snapshots();
  }
}
