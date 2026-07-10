class MqttService {
  Future<void> connect() async {
    print("MQTT Connected");
  }

  Future<void> disconnect() async {
    print("MQTT Disconnected");
  }
}
