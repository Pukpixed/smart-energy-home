import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/energy_provider.dart';

class EnergyScreen extends StatefulWidget {
  const EnergyScreen({super.key});

  @override
  State<EnergyScreen> createState() => _EnergyScreenState();
}

class _EnergyScreenState extends State<EnergyScreen> {
  @override
  Widget build(BuildContext context) {
    final energyList = context.watch<EnergyProvider>().energyList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Monitor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: energyList.isEmpty
            ? const Center(
                child: Text('No energy data'),
              )
            : ListView.builder(
                itemCount: energyList.length,
                itemBuilder: (context, index) {
                  final item = energyList[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.bolt),
                      title: Text(
                        '${item.value.toStringAsFixed(2)} kWh',
                      ),
                      subtitle: Text(
                        item.time.toString(),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
