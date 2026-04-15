import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/header.dart';
import '../widgets/cards.dart';
import '../data/mock_data.dart';
import '../models/post.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  void _handleNavigation(BuildContext context, String item) {
    switch (item) {
      case 'Dashboard':
      //i use pushnamed to switch between the screeens
      //i copy and paste them on the 4 screens
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
  //this is for the color for every status


  Color _getStatusColor(String status) {
    switch (status) {
      //if the status is pending go orange
    //and etc
      case 'Pending':
        return Colors.orange;
      case 'Resolved':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      case 'Done':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
//this is to create the table
  Widget _buildTableRow(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFC4C4C4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(child: Text(post.id, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(post.itemName, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(post.type, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(post.owner, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(post.reportedBy, textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: Text(
              post.status,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getStatusColor(post.status),
              ),
            ),
          ),
          Expanded(flex: 2, child: Text(post.date, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Post> posts = mockPosts;
//we use the data from the post , but i need to chnage it so it goes to the backend
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
                        label: 'Returned to Security',
                        count: '5',
                        icon: Icons.shield,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(width: 12),
                      SummaryCard(
                        label: 'Pending Items',
                        count: '2',
                        icon: Icons.hourglass_empty,
                        color: Colors.brown,
                      ),
                    ],
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
                                    'Owner',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Reported By',
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
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return _buildTableRow(posts[index]);
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