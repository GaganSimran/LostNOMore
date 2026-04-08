import 'package:flutter/material.dart';
import 'lost_screen.dart';
import 'found_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
                    fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "Discover what's happening on Campus",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const Divider(height: 30),

              // Grey Box containing Lost / Found
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
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

  Widget _buildActionButton(BuildContext context,
      {required String question,
        required String label,
        required Color color,
        required Widget navigateTo}) {
    return Column(
      children: [
        Text(
          question,
          textAlign: TextAlign.center,  // Center the question
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
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