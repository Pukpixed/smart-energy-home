import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> testFirestore() async {
  await FirebaseFirestore.instance.collection('devices').add({
    'name': 'Test Device',
    'status': true,
    'power': 100,
  });

  print('Firestore Connected');
}
