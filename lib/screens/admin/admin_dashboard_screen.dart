import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Widget card(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin")),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          card("Users", "120"),
          card("Devices", "350"),
          card("Energy", "25000"),
          card("Alerts", "15"),
        ],
      ),
    );
  }
}
