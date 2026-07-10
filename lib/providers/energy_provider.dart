import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/energy_model.dart';

class EnergyProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<EnergyModel> _energyList = [];
  List<EnergyModel> get energyList => _energyList;

  void listenEnergy(String uid) {
    _firestore
        .collection('energy_logs')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
          _energyList = snapshot.docs
              .map((doc) => EnergyModel.fromMap(doc.data()))
              .toList();

          notifyListeners();
        });
  }
}
