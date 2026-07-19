import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  MQTTService._();

  static final MQTTService instance = MQTTService._();

  late MqttServerClient client;

  final String broker = "broker.hivemq.com";

  final int port = 1883;

  Future<void> connect() async {
    client = MqttServerClient(
      broker,
      "smart_energy_flutter",
    );

    client.port = port;

    client.keepAlivePeriod = 30;

    client.logging(
      on: false,
    );

    client.onConnected = () {
      print(
        "MQTT Connected",
      );
    };

    client.onDisconnected = () {
      print(
        "MQTT Disconnected",
      );
    };

    try {
      await client.connect();
    } catch (e) {
      print(
        "MQTT Error : $e",
      );

      client.disconnect();
    }
  }

  void subscribe(
    String topic, {
    required Function(String message) onMessage,
  }) {
    client.subscribe(
      topic,
      MqttQos.atLeastOnce,
    );

    client.updates?.listen((events) {
      final MqttPublishMessage message =
          events[0].payload as MqttPublishMessage;

      final String payload = MqttPublishPayload.bytesToStringAsString(
        message.payload.message,
      );

      print(
        "MQTT DATA : $payload",
      );

      onMessage(payload);
    });
  }

  void publish(
    String topic,
    String message,
  ) {
    final builder = MqttClientPayloadBuilder();

    builder.addString(
      message,
    );

    client.publishMessage(
      topic,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }

  void disconnect() {
    client.disconnect();
  }
}
