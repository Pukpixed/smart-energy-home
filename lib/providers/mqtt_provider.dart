import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/services/mqtt_service.dart';
import '../core/services/firebase_service.dart';

class MQTTProvider extends ChangeNotifier {
  final MQTTService mqtt = MQTTService.instance;

  final FirebaseService firebase = FirebaseService.instance;

  bool _connected = false;

  bool get connected => _connected;

  Map<String, dynamic>? _latestEnergy;

  Map<String, dynamic>? get latestEnergy => _latestEnergy;

  Future<void> connectMQTT() async {
    try {
      await mqtt.connect();

      _connected = true;

      notifyListeners();

      subscribeEnergy();
    } catch (e) {
      debugPrint(
        "MQTT Provider Error : $e",
      );

      _connected = false;

      notifyListeners();
    }
  }

  void subscribeEnergy() {
    mqtt.subscribe(
      "smart_home/energy/device01",
      onMessage: (String message) async {
        try {
          final Map<String, dynamic> data = jsonDecode(message);

          _latestEnergy = data;

          notifyListeners();

          await firebase.addData(
            collection: "energy_logs",
            data: {
              "userId": "system",
              "voltage": data["voltage"] ?? 0,
              "current": data["current"] ?? 0,
              "power": data["power"] ?? 0,
              "energy": data["energy"] ?? 0,
              "timestamp": DateTime.now(),
            },
          );
        } catch (e) {
          debugPrint(
            "MQTT DATA ERROR : $e",
          );
        }
      },
    );
  }

  void sendDeviceCommand(
    String deviceId,
    bool status,
  ) {
    mqtt.publish(
      "smart_home/device/$deviceId/control",
      jsonEncode({"status": status ? "ON" : "OFF"}),
    );
  }

  void disconnectMQTT() {
    mqtt.disconnect();

    _connected = false;

    notifyListeners();
  }
}
