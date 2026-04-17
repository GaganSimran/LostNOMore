import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/header.dart';
import '../widgets/cards.dart';
import '../Models/item_model.dart';
import '../Models/item_service.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  late Future<List<Item>> futureItems;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureItems = ItemService.fetchItems();
  }

  void _handleNavigation(BuildContext context, String item) {
    switch (item) {
      case 'Dashboard':
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 'Manage Posts':
        break;
      case 'Reports':
        Navigator.pushNamed(context, '/reports');
        break;
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }
  Future<void> _denyItem(int id) async {
    try {
      await ItemService.deleteItem(id);
      setState(() {
        futureItems = ItemService.fetchItems();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete item: $e')),
      );
    }
  }

  Future<void> _updateStatus(int id, String status) async {
    try {
      await ItemService.updateItemStatus(id, status);

      setState(() {
        futureItems = ItemService.fetchItems();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'denied':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Widget _buildTableRow(Item item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFC4C4C4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.id.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.title,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.type,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.category,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.location,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.status,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getStatusColor(item.status),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.createdAt.toString().split(' ').first,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: item.status.toLowerCase() == 'pending'
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _updateStatus(item.id, 'approved'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Accept'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _denyItem(item.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Deny'),
                ),
              ],
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Row(
        children: [
          AppSidebar(
            selected: 'Manage Posts',
            onItemTap: (item) => _handleNavigation(context, item),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(title: 'Admin Panel'),
                  const SizedBox(height: 30),
                  FutureBuilder<List<Item>>(
                    future: futureItems,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Row(
                          children: [
                            SummaryCard(
                              label: 'Total Lost Items',
                              count: '0',
                              icon: Icons.search,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 12),
                            SummaryCard(
                              label: 'Total Found Items',
                              count: '0',
                              icon: Icons.check_circle,
                              color: Colors.green,
                            ),
                            SizedBox(width: 12),
                            SummaryCard(
                              label: 'Returned to Security',
                              count: '0',
                              icon: Icons.shield,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(width: 12),
                            SummaryCard(
                              label: 'Pending Items',
                              count: '0',
                              icon: Icons.hourglass_empty,
                              color: Colors.brown,
                            ),
                          ],
                        );
                      }

                      final items = snapshot.data!;
                      final totalLost = items
                          .where((item) => item.type.toLowerCase() == 'lost')
                          .length;
                      final totalFound = items
                          .where((item) => item.type.toLowerCase() == 'found')
                          .length;
                      final returnedToSecurity = items
                          .where((item) => item.handedToSecurity == true)
                          .length;
                      final pendingItems = items
                          .where((item) => item.status.toLowerCase() == 'pending')
                          .length;

                      return Row(
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
                            label: 'Returned to Security',
                            count: returnedToSecurity.toString(),
                            icon: Icons.shield,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(width: 12),
                          SummaryCard(
                            label: 'Pending Items',
                            count: pendingItems.toString(),
                            icon: Icons.hourglass_empty,
                            color: Colors.brown,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Manage Posts',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 320,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search Items...',
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCCCCCC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'ID',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Item',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Type',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Category',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Location',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Status',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Date',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Actions',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: FutureBuilder<List<Item>>(
                              future: futureItems,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }

                                final items = snapshot.data ?? [];

                                final filteredItems = items.where((item) {
                                  final query = searchQuery.toLowerCase();
                                  return item.title.toLowerCase().contains(query) ||
                                      item.category.toLowerCase().contains(query) ||
                                      item.location.toLowerCase().contains(query) ||
                                      item.status.toLowerCase().contains(query) ||
                                      item.type.toLowerCase().contains(query);
                                }).toList();

                                if (filteredItems.isEmpty) {
                                  return const Center(
                                    child: Text('No recent activity'),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    return _buildTableRow(filteredItems[index]);
                                  },
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
            ),
          ),
        ],
      ),
    );
  }
}