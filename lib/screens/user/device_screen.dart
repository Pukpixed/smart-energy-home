import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final devicesRef = FirebaseFirestore.instance.collection('devices');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Devices Control"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: devicesRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final devices = snapshot.data!.docs;

          if (devices.isEmpty) {
            return const Center(child: Text("No devices found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final doc = devices[index];
              final data = doc.data() as Map<String, dynamic>;

              final String name = data['name'] ?? 'Unknown';
              final String room = data['room'] ?? 'Room';
              final double power = (data['powerUsage'] ?? 0).toDouble();
              final bool status = data['status'] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 📱 DEVICE INFO
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Room: $room",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Power: ${power.toStringAsFixed(0)} W",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    // 🔌 SWITCH CONTROL
                    Switch(
                      value: status,
                      activeThumbColor: const Color(0xFF4F46E5),
                      onChanged: (value) async {
                        await devicesRef.doc(doc.id).update({"status": value});
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
