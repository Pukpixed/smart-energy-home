import 'package:flutter/material.dart';

class EnergyScreen extends StatelessWidget {
  const EnergyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Energy Analytics")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.today),
              title: const Text("Today Usage"),
              trailing: const Text("5.2 kWh"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("Monthly Usage"),
              trailing: const Text("152 kWh"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text("Yearly Usage"),
              trailing: const Text("1840 kWh"),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text("Energy Chart")),
          ),
        ],
      ),
    );
  }
}
