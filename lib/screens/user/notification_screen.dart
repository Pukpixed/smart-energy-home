import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.warning, color: Colors.orange),
            title: Text("Energy usage exceeds target"),
            subtitle: Text("Current usage 5.2 kWh"),
          ),

          ListTile(
            leading: Icon(Icons.devices, color: Colors.red),
            title: Text("ESP32 Offline"),
          ),
        ],
      ),
    );
  }
}
