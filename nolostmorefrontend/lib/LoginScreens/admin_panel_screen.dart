import 'package:flutter/material.dart';
import 'admin_settings_screen.dart';
class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> posts = [
      {
        "id": "001",
        "itemName": "Wallet",
        "type": "Lost",
        "owner": "John Doe",
        "reportedBy": "John Doe",
        "status": "Pending",
        "security": "Yes",
        "date": "Mar 23, 2026",
      },
      {
        "id": "002",
        "itemName": "Phone",
        "type": "Found",
        "owner": "Gumsiram",
        "reportedBy": "Alex B",
        "status": "Resolved",
        "security": "Yes",
        "date": "Mar 23, 2026",
      },
      {
        "id": "003",
        "itemName": "Backpack",
        "type": "Lost",
        "owner": "Francis B",
        "reportedBy": "Francis B",
        "status": "In Progress",
        "security": "Yes",
        "date": "Mar 23, 2026",
      },
      {
        "id": "004",
        "itemName": "Keys",
        "type": "Found",
        "owner": "Krish P",
        "reportedBy": "Krish P",
        "status": "Done",
        "security": "Yes",
        "date": "Mar 23, 2026",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Row(
          children: [
            const _Sidebar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _TopBar(),
                    const SizedBox(height: 22),

                    const Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.search,
                            title: "Total Lost Items",
                            value: "120",
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.check_circle,
                            title: "Total Found Items",
                            value: "98",
                            iconColor: Colors.green,
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.shield,
                            title: "Return to Security",
                            value: "15",
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.hourglass_empty,
                            title: "Pending Items",
                            value: "24",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEDED),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Manage Posts",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 240,
                                  height: 40,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Search Items...",
                                      prefixIcon: const Icon(Icons.search),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "Lost & Found",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: 500,
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search Items...",
                                  prefixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: const Color(0xFFD9D9D9),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            _buildTableHeader(),

                            const SizedBox(height: 10),

                            Expanded(
                              child: ListView.separated(
                                itemCount: posts.length,
                                separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final post = posts[index];
                                  return _buildTableRow(post);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD2D2D2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Expanded(flex: 1, child: Text("ID", textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("Item Name", textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("Type", textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("Owner", textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("Reported By", textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("Status", textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("Security", textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("Date", textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, String> post) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(post["id"]!, textAlign: TextAlign.center)),
          Expanded(
              flex: 2,
              child: Text(post["itemName"]!, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(post["type"]!, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(post["owner"]!, textAlign: TextAlign.center)),
          Expanded(
              flex: 2,
              child: Text(post["reportedBy"]!, textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: Text(
              post["status"]!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _getStatusColor(post["status"]!),
              ),
            ),
          ),
          Expanded(
              flex: 2, child: Text(post["security"]!, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(post["date"]!, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Resolved":
        return Colors.green;
      case "In Progress":
        return Colors.blue;
      case "Done":
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1400FF), Color(0xFF0B00B0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "PANEL 1 NEED TO CHANGE FRANCIS NEED TOO ADD DATA ",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 16),

            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Lost & Found",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 42),

            _SidebarItem(
              title: "Manage Posts",
              icon: Icons.workspace_premium,
              selected: true,
            ),
            _SidebarItem(
              title: "Dashboard",
              icon: Icons.home_outlined,
            ),
            _SidebarItem(
              title: "Reports",
              icon: Icons.assignment_outlined,
            ),
            _SidebarItem(
              title: "Settings",
              icon: Icons.settings_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminSettingsScreen(),
                  ),
                );
              },
            ),

            const Spacer(),

            const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black26,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Admin", style: TextStyle(color: Colors.white)),
                      SizedBox(height: 4),
                      Text(
                        "biller@gmail.com",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.title,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w400,
                ),
              ),
            ),
            Icon(
              icon,
              color: selected ? Colors.orangeAccent : Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Admin Panel",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        const Icon(Icons.search, color: Colors.black54, size: 28),
        const SizedBox(width: 20),
        SizedBox(
          width: 180,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search...",
              border: InputBorder.none,
              isDense: true,
              hintStyle: const TextStyle(color: Colors.black54),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black54, width: 2),
          ),
          child: const Icon(Icons.person_outline, size: 34),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}