import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget buildCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(title),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Energy Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            buildCard("Voltage", "220V", Icons.bolt),
            buildCard("Current", "5.1A", Icons.electric_meter),
            buildCard("Power", "1120W", Icons.flash_on),
            buildCard("Energy", "23.5 kWh", Icons.bar_chart),
          ],
        ),
      ),
    );
  }
}
