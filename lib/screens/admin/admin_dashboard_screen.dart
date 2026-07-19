import 'package:flutter/material.dart';

import 'device_management_screen.dart';
import 'report_screen.dart';
import 'settings_screen.dart';
import 'user_management_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF071C24);
    const primary = Color(0xFF41D6C3);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _menu(
              context,
              Icons.people,
              "จัดการผู้ใช้",
              const UserManagementScreen(),
            ),
            _menu(
              context,
              Icons.electrical_services,
              "จัดการอุปกรณ์",
              const DeviceManagementScreen(),
            ),
            _menu(
              context,
              Icons.bar_chart,
              "รายงาน",
              const ReportScreen(),
            ),
            _menu(
              context,
              Icons.settings,
              "ตั้งค่าระบบ",
              const SettingsScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menu(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Card(
        color: const Color(0xFF0C2731),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Icon(
              icon,
              color: const Color(0xFF41D6C3),
              size: 50,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            )
          ],
        ),
      ),
    );
  }
}
