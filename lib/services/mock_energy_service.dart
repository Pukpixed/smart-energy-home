import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class MockEnergyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _timer;

  void start(String userId) {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final random = Random();

      double value = 5 + random.nextDouble() * 20; // 5 - 25 kW

      await _firestore.collection('energy_logs').add({
        'userId': userId,
        'value': value,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }

  void stop() {
    _timer?.cancel();
  }
}
