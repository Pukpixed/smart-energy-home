import 'package:cloud_firestore/cloud_firestore.dart';

class EnergyModel {
  final String id;
  final String userId;
  final double voltage;
  final double current;
  final double power;
  final double energy;
  final DateTime timestamp;

  EnergyModel({
    required this.id,
    required this.userId,
    required this.voltage,
    required this.current,
    required this.power,
    required this.energy,
    required this.timestamp,
  });

  factory EnergyModel.fromMap(Map<String, dynamic> map, String documentId) {
    return EnergyModel(
      id: documentId,
      userId: map['userId'] ?? '',
      voltage: (map['voltage'] ?? 0).toDouble(),
      current: (map['current'] ?? 0).toDouble(),
      power: (map['power'] ?? 0).toDouble(),
      energy: (map['energy'] ?? 0).toDouble(),
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'voltage': voltage,
      'current': current,
      'power': power,
      'energy': energy,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
