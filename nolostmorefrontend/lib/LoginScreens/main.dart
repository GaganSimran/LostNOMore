import 'package:flutter/material.dart';
import 'home_screen.dart';  // Make sure this file exists

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Set a sample username here
  final String loggedInUser = "Haley";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'No Lost More',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(username: loggedInUser),
    );
  }
}