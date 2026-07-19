import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../models/device_model.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DeviceProvider>().fetchDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeviceProvider>();
    final List<DeviceModel> devices = provider.devices;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Control"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await provider.fetchDevices();
        },
        child: devices.isEmpty
            ? const Center(
                child: Text(
                  "ไม่พบอุปกรณ์",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Icon(
                        device.type == "light"
                            ? Icons.lightbulb
                            : Icons.electrical_services,
                        color: device.status ? Colors.green : Colors.grey,
                      ),
                      title: Text(device.name),
                      subtitle: Text(
                        "${device.room}\nPower : ${device.power.toStringAsFixed(2)} W",
                      ),
                      isThreeLine: true,
                      trailing: Switch(
                        value: device.status,
                        onChanged: (_) async {
                          await provider.toggleDevice(device);
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
