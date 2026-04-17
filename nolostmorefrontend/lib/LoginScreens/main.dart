import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'admin_panel_screen.dart';
import 'admin_settings_screen.dart';
import 'reports_screen.dart';
import 'login_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'No Lost More',

      // Start page
      initialRoute: '/',

      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/panel': (context) => const AdminPanelScreen(),
        '/settings': (context) => const AdminSettingsScreen(),
        '/reports': (context) => const ReportsScreen(),
      },
    );
  }
}