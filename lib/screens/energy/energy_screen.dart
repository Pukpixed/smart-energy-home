import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/energy_provider.dart';
import '../../models/energy_model.dart';

class EnergyScreen extends StatefulWidget {
  const EnergyScreen({super.key});

  @override
  State<EnergyScreen> createState() => _EnergyScreenState();
}

class _EnergyScreenState extends State<EnergyScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EnergyProvider>().fetchEnergyLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EnergyProvider>();

    final List<EnergyModel> energyList = provider.energyLogs;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Energy Monitor',
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await provider.fetchEnergyLogs();
        },
        child: energyList.isEmpty
            ? const Center(
                child: Text(
                  'No energy data',
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: energyList.length,
                itemBuilder: (context, index) {
                  final item = energyList[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(
                          Icons.bolt,
                        ),
                      ),
                      title: Text(
                        "${item.energy.toStringAsFixed(2)} kWh",
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Voltage : ${item.voltage.toStringAsFixed(1)} V",
                          ),
                          Text(
                            "Current : ${item.current.toStringAsFixed(2)} A",
                          ),
                          Text(
                            "Power : ${item.power.toStringAsFixed(2)} W",
                          ),
                          Text(
                            "Time : ${item.timestamp}",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
