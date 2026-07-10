class EnergyModel {
  final double value;
  final DateTime time;

  EnergyModel({required this.value, required this.time});

  factory EnergyModel.fromMap(Map<String, dynamic> map) {
    return EnergyModel(
      value: (map['value'] ?? 0).toDouble(),
      time: (map['timestamp'] as dynamic).toDate(),
    );
  }
}
