import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'providers/device_provider.dart';
import 'providers/energy_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/report_provider.dart';
import 'providers/mqtt_provider.dart';

import 'screens/auth/welcome_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const SmartEnergyApp(),
  );
}

class SmartEnergyApp extends StatelessWidget {
  const SmartEnergyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => DeviceProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => EnergyProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ReportProvider(),
        ),

        // MQTT
        ChangeNotifierProvider(
          create: (_) => MQTTProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Smart Energy Home',
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: const Color(0xFF41D6C3),
              fontFamily: 'Kanit',
            ),
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        if (auth.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (auth.user != null) {
          final mqtt = context.read<MQTTProvider>();

          if (!mqtt.connected) {
            mqtt.connectMQTT();
          }

          return const DashboardScreen();
        }

        return const WelcomeScreen();
      },
    );
  }
}
