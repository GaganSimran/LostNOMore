import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: const Color(0xFF1A237E),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.search, color: Colors.white, size: 40),
                const Text(
                  "Lost & Found",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 30),

                _sidebarItem(Icons.dashboard, "Dashboard", selected: true),

                _sidebarItem(Icons.search, "Lost Items", onTap: () {}),
                _sidebarItem(Icons.check_circle, "Found Items", onTap: () {}),
                _sidebarItem(Icons.bar_chart, "Reports", onTap: () {}),

                _sidebarItem(Icons.settings, "Settings", onTap: () {
                  Navigator.pushNamed(context, '/settings');
                }),

                const Spacer(),

                const ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.white24),
                  title: Text("Admin",
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text("admin@mail.com",
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),

                  // Stats
                  Row(
                    children: [
                      _statCard("Total Lost Items", "25", Icons.search, Colors.grey),
                      _statCard("Total Found Items", "6", Icons.check_circle, Colors.green),
                      _statCard("Returned Items", "5", Icons.shield, Colors.blueGrey),
                      _statCard("Pending", "2", Icons.person_search, Colors.brown),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Recent Activity",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView(
                      children: [
                        _activityTile(Icons.search,
                            "John Doe reported a lost wallet", "2 hours ago"),
                        _activityTile(Icons.check_circle,
                            "Phone found near campus", "Aug 24, 2025",
                            iconColor: Colors.green),
                        _activityTile(Icons.shield,
                            "Laptop returned to security", "May 20, 2025"),
                        _activityTile(Icons.search,
                            "Keys reported missing", "May 22, 2024"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar item
  Widget _sidebarItem(IconData icon, String title,
      {bool selected = false, VoidCallback? onTap}) {
    return Container(
      color: selected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: onTap,
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Dashboard",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 20),
            CircleAvatar(child: Icon(Icons.person)),
          ],
        )
      ],
    );
  }

  // Stat card
  Widget _statCard(
      String label, String count, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54)),
                  Text(count,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Activity tile
  Widget _activityTile(IconData icon, String text, String time,
      {Color iconColor = Colors.grey}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing:
        Text(time, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}