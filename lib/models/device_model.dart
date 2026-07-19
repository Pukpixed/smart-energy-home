class DeviceModel {
  final String id;
  final String name;
  final String type;
  final bool status;
  final double power;
  final String room;

  DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.power,
    required this.room,
  });

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      status: map['status'] ?? false,
      power: (map['power'] ?? 0).toDouble(),
      room: map['room'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'power': power,
      'room': room,
    };
  }
}
