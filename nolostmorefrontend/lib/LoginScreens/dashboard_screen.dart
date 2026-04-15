import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/header.dart';
import '../widgets/cards.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _handleNavigation(BuildContext context, String item) {
    switch (item) {
      case 'Dashboard':
        break;
      case 'Manage Posts':
        //i use pushnamed to switch between the screeens
        Navigator.pushNamed(context, '/panel');
        break;
      case 'Reports':
        Navigator.pushNamed(context, '/reports');
        break;
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Row(
        children: [
          AppSidebar(
            selected: 'Dashboard',
            onItemTap: (item) => _handleNavigation(context, item),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(title: 'Dashboard'),
                  const SizedBox(height: 30),

                  const Row(
                    children: [
                      SummaryCard(
                        label: 'Total Lost Items',
                        count: '25',
                        icon: Icons.search,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 12),
                      SummaryCard(
                        label: 'Total Found Items',
                        count: '6',
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                      SizedBox(width: 12),
                      SummaryCard(
                        label: 'Returned Items',
                        count: '5',
                        icon: Icons.shield,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(width: 12),
                      SummaryCard(
                        label: 'Pending',
                        count: '2',
                        icon: Icons.person_search,
                        color: Colors.brown,
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView(
                      children: const [
                        _ActivityTile(
                          icon: Icons.search,
                          text: 'John Doe reported a lost wallet',
                          time: '2 hours ago',
                        ),
                        _ActivityTile(
                          icon: Icons.check_circle,
                          text: 'Phone found near campus',
                          time: 'Aug 24, 2025',
                          iconColor: Colors.green,
                        ),
                        _ActivityTile(
                          icon: Icons.shield,
                          text: 'Laptop returned to security',
                          time: 'May 20, 2025',
                        ),
                        _ActivityTile(
                          icon: Icons.search,
                          text: 'Keys reported missing',
                          time: 'May 22, 2024',
                        ),
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
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final String time;
  final Color iconColor;

  const _ActivityTile({
    required this.icon,
    required this.text,
    required this.time,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Text(
          time,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}