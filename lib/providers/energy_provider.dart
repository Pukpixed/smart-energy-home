import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/energy_model.dart';

class EnergyProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<EnergyModel> _energyLogs = [];

  List<EnergyModel> get energyLogs => _energyLogs;

  bool _loading = false;

  bool get loading => _loading;

  double _todayEnergy = 0;

  double get todayEnergy => _todayEnergy;

  double _todayPower = 0;

  double get todayPower => _todayPower;

  Future<void> fetchEnergyLogs() async {
    try {
      _loading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection("energy_logs")
          .orderBy("timestamp", descending: true)
          .get();

      _energyLogs = snapshot.docs
          .map((e) => EnergyModel.fromMap(e.data(), e.id))
          .toList();

      calculateSummary();

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();

      debugPrint(e.toString());
    }
  }

  void calculateSummary() {
    _todayEnergy = 0;
    _todayPower = 0;

    for (var item in _energyLogs) {
      _todayEnergy += item.energy;
      _todayPower += item.power;
    }
  }

  Future<void> addEnergy(EnergyModel model) async {
    try {
      await _firestore.collection("energy_logs").add(model.toMap());

      fetchEnergyLogs();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
