class DeviceModel {
  final String id;
  final String name;
  final String type;
  final bool status;
  final double power;

  DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.power,
  });

  factory DeviceModel.fromMap(String id, Map<String, dynamic> map) {
    return DeviceModel(
      id: id,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      status: map['status'] ?? false,
      power: (map['power'] ?? 0).toDouble(),
    );
  }
}
