import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/device_provider.dart';
import '../../providers/energy_provider.dart';

import '../../models/device_model.dart';

import '../device/device_screen.dart';
import '../energy/energy_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EnergyProvider>().fetchEnergyLogs();

      context.read<DeviceProvider>().fetchDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final energyProvider = context.watch<EnergyProvider>();

    final deviceProvider = context.watch<DeviceProvider>();

    final energy = energyProvider.energyLogs;

    final devices = deviceProvider.devices;

    final double totalEnergy = energy.fold(
      0,
      (sum, item) => sum + item.energy,
    );

    final double cost = totalEnergy * 4.2;

    final int activeDevices = devices
        .where(
          (device) => device.status,
        )
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Smart Energy Home",
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () async {
              await auth.logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<EnergyProvider>().fetchEnergyLogs();

          await context.read<DeviceProvider>().fetchDevices();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(
                    Icons.person,
                  ),
                ),
                title: Text(
                  auth.user?.displayName ?? "ผู้ใช้งาน",
                ),
                subtitle: Text(
                  auth.user?.email ?? "",
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.bolt,
                ),
                title: const Text(
                  "พลังงานที่ใช้",
                ),
                subtitle: Text(
                  "${totalEnergy.toStringAsFixed(2)} kWh",
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.payments,
                ),
                title: const Text(
                  "ค่าไฟประมาณการ",
                ),
                subtitle: Text(
                  "฿${cost.toStringAsFixed(2)}",
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.devices,
                ),
                title: const Text(
                  "อุปกรณ์ที่เปิดใช้งาน",
                ),
                subtitle: Text(
                  "$activeDevices เครื่อง",
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.show_chart,
                ),
                label: const Text(
                  "ดูข้อมูลพลังงาน",
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EnergyScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.power,
                ),
                label: const Text(
                  "ควบคุมอุปกรณ์",
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DeviceScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
