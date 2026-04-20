import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 24),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _teamMember(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 16, color: Colors.blue),
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: const [
          Icon(Icons.info_outline, size: 50, color: Colors.white),
          SizedBox(height: 10),
          Text(
            "NoLostMore",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Find • Connect • Recover",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _header(),

            _sectionTitle("About This Project"),
            _card(
              const Text(
                "This application is developed as part of a college capstone project for showcase purposes. It demonstrates real-world problem solving, backend integration, and full-stack mobile development. The system is designed with scalability in mind and can be extended for production deployment in the future.",
                style: TextStyle(fontSize: 14, height: 1.6),
              ),
            ),

            _sectionTitle("Team Members"),
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _teamMember("Krish Patel"),
                  _teamMember("Francis Biller"),
                  _teamMember("Simran Kaur"),
                ],
              ),
            ),

            _sectionTitle("Legal & Privacy"),
            _card(
              const Text(
                "This application is intended for educational and demonstration purposes only. All data handling within this project follows basic privacy principles. Future production deployment may include enhanced security, authentication policies, and compliance adjustments based on requirements.",
                style: TextStyle(fontSize: 14, height: 1.6),
              ),
            ),

            _sectionTitle("Future Scope"),
            _card(
              const Text(
                "The platform can be further enhanced with advanced features such as real-time tracking, AI-based matching systems, cloud scalability, and improved user experience. Additional improvements and changes can be implemented as needed for real-world deployment.",
                style: TextStyle(fontSize: 14, height: 1.6),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}