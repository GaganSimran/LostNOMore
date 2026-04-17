import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/header.dart';
import '../widgets/cards.dart';
import '../Models/item_model.dart';
import '../Models/item_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalLost = 0;
  int totalFound = 0;
  int returned = 0;
  int pending = 0;

  List<Item> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final fetchedItems = await ItemService.fetchItems();

      int lost = 0;
      int found = 0;
      int returnedCount = 0;
      int pendingCount = 0;

      for (var item in fetchedItems) {
        if (item.type.toLowerCase() == 'lost') lost++;
        if (item.type.toLowerCase() == 'found') found++;
        if (item.handedToSecurity == true) returnedCount++;
        if (item.status.toLowerCase() == 'pending') pendingCount++;
      }

      setState(() {
        items = fetchedItems;
        totalLost = lost;
        totalFound = found;
        returned = returnedCount;
        pending = pendingCount;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load dashboard data: $e')),
      );
    }
  }

  void _handleNavigation(BuildContext context, String item) {
    switch (item) {
      case 'Dashboard':
        break;
      case 'Manage Posts':
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

  String _getText(Item item) {
    if (item.handedToSecurity) {
      return '${item.title} was handed to security';
    } else if (item.type.toLowerCase() == 'found') {
      return '${item.title} reported as found';
    } else {
      return '${item.title} reported as lost';
    }
  }

  IconData _getIcon(Item item) {
    if (item.status.toLowerCase() == 'pending') return Icons.person_search;
    if (item.handedToSecurity) return Icons.shield;
    if (item.type.toLowerCase() == 'found') return Icons.check_circle;
    return Icons.search;
  }

  Color _getColor(Item item) {
    if (item.status.toLowerCase() == 'pending') return Colors.brown;
    if (item.handedToSecurity) return Colors.blueGrey;
    if (item.type.toLowerCase() == 'found') return Colors.green;
    return Colors.grey;
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hrs ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
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

                  Row(
                    children: [
                      SummaryCard(
                        label: 'Total Lost Items',
                        count: totalLost.toString(),
                        icon: Icons.search,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      SummaryCard(
                        label: 'Total Found Items',
                        count: totalFound.toString(),
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      SummaryCard(
                        label: 'Returned Items',
                        count: returned.toString(),
                        icon: Icons.shield,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 12),
                      SummaryCard(
                        label: 'Pending',
                        count: pending.toString(),
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
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : items.isEmpty
                        ? const Center(
                      child: Text(
                        'No recent activity',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                        : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return _ActivityTile(
                          icon: _getIcon(item),
                          text: _getText(item),
                          time: _formatTime(item.createdAt),
                          iconColor: _getColor(item),
                        );
                      },
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