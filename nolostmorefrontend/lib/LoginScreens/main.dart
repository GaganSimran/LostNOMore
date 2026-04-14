import 'package:flutter/material.dart';
import 'admin_panel_screen.dart';
import 'admin_settings_screen.dart';

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
      home: const AdminSettingsScreen(),
    );
  }
}