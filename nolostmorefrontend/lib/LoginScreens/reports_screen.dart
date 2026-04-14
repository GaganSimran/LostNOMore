import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Row(
        children: [
          // ================= SIDEBAR =================
          Container(
            width: 200,
            color: const Color(0xFF3D47FF),
            child: Column(
              children: [
                const SizedBox(height: 40),

                _buildSidebarItem(
                  context,
                  Icons.dashboard,
                  "Dashboard",
                  onTap: () => Navigator.pushNamed(context, '/panel'),
                ),

                _buildSidebarItem(
                  context,
                  Icons.settings,
                  "Settings",
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),

                _buildSidebarItem(
                  context,
                  Icons.assignment,
                  "Reports",
                  isActive: true,
                  onTap: () => Navigator.pushNamed(context, '/reports'),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: const [
                      CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Admin",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text("admin@gmail.com",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 10)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          // ================= MAIN AREA =================
          Expanded(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 20),
                      Icon(Icons.account_circle_outlined,
                          size: 35, color: Colors.grey),
                    ],
                  ),
                ),

                // Card
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Reports",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        const SizedBox(height: 20),

                        // HEADER
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFCCCCCC),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Text("User",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text("# Reports",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // LIST
                        Expanded(
                          child: ListView(
                            children: [
                              _buildRow("Francis Biller", "2"),
                              _buildRow("Krish Patel", "1"),
                              _buildRow("Julian Marin", "1"),
                              _buildRow("Brandon Bea", "1"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // ================= SIDEBAR ITEM =================
  Widget _buildSidebarItem(
      BuildContext context,
      IconData icon,
      String title, {
        bool isActive = false,
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // ================= TABLE ROW =================
  static Widget _buildRow(String name, String count) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFC4C4C4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(flex: 3, child: Text(name)),
          Expanded(
              child: Text(count, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}