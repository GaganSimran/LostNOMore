import 'package:flutter/material.dart';
import 'lost_screen.dart';   // Make sure this file has class LostScreen
import 'found_screen.dart';  // Make sure this file has class FoundScreen

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Main Body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                "Hello, $username",
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "What would you like to do today?",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const Divider(height: 30),

              // Action Buttons
              _buildActionButton(
                context,
                question: "Missing something?",
                label: "Lost",
                color: Colors.red[900]!,
                navigateTo: LostScreen(),
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                context,
                question: "Found something?",
                label: "Found",
                color: Colors.green[800]!,
                navigateTo: FoundScreen(),
              ),
            ],
          ),
        ),
      ),

      // Fixed Footer Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: "Post"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  // Widget to build the action button
  Widget _buildActionButton(BuildContext context,
      {required String question,
        required String label,
        required Color color,
        required Widget navigateTo}) {
    return Column(
      children: [
        Text(question, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => navigateTo),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}