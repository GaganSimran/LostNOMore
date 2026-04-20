import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nolostmorefrontend/firebase_options.dart';

import 'dashboard_screen.dart';
import 'admin_panel_screen.dart';
import 'admin_settings_screen.dart';
import 'reports_screen.dart';
import 'login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'No Lost More',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/panel': (context) => const AdminPanelScreen(),
        '/settings': (context) => const AdminSettingsScreen(),
        '/reports': (context) => const ReportsScreen(),
      },
    );
  }
}