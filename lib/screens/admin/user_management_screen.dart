import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("จัดการผู้ใช้")),
      body: const Center(
        child: Text("หน้าจัดการผู้ใช้"),
      ),
    );
  }
}
