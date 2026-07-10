import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final String userId = "userId123";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DeviceProvider>().listenDevices(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final devices = context.watch<DeviceProvider>().devices;

    return Scaffold(
      appBar: AppBar(title: const Text("🔌 Device Control"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final d = devices[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Icon(
                  d.type == "light"
                      ? Icons.lightbulb
                      : Icons.electrical_services,
                  color: d.status ? Colors.green : Colors.grey,
                ),
                title: Text(d.name),
                subtitle: Text("Power: ${d.power} W"),
                trailing: Switch(
                  value: d.status,
                  onChanged: (value) {
                    context.read<DeviceProvider>().toggleDevice(d.id, value);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
