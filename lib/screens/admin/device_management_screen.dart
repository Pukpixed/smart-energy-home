import 'package:flutter/material.dart';

class DeviceManagementScreen extends StatelessWidget {
  const DeviceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("จัดการอุปกรณ์")),
      body: const Center(
        child: Text("หน้าจัดการอุปกรณ์"),
      ),
    );
  }
}
