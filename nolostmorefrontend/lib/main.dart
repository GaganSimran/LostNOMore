import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nolostmorefrontend/LoginScreens/home_screen.dart';
import 'package:nolostmorefrontend/LoginScreens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'LoginScreens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double brightness = 1.0;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'No Lost More',

      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),

      home: Stack(
        children: [
         // HomeScreen(username: "Krish", userId: 123, profileImage: "profileImage", bio: "Shutup"),
          LoginScreen(),

          // 🔥 GLOBAL BRIGHTNESS OVERLAY
          IgnorePointer(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: Colors.black.withOpacity(1 - brightness),
            ),
          ),
        ],
      ),
    );
  }
}