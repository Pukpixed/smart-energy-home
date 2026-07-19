import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ตั้งค่าระบบ")),
      body: const Center(
        child: Text("หน้าตั้งค่าระบบ"),
      ),
    );
  }
}
