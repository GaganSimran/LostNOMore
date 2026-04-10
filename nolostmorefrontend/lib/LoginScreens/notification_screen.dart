import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final String username;

  const NotificationScreen({super.key, required this.username});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedBottomIndex = 3; // Notifications tab
  String _selectedFilter = 'Last 24 hours'; // Default selected filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage:
            NetworkImage('https://via.placeholder.com/150'),
          ),
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey[200],
            filled: true,
          ),
        ),
      ),

      // BODY
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Notification Center',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // FILTER CHIPS AS BUTTONS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('Last 24 hours'),
                _buildFilterChip('Last week'),
                _buildFilterChip('Last month'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // NOTIFICATION LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildNotificationTile(
                    'Most commonly reported items on campus. Tap to view list.',
                    '1 hr',
                    Icons.list_alt),
                _buildNotificationTile(
                    'Found a set of car keys in parking lot B.', '2 hr', Icons.vpn_key),
                _buildNotificationTile(
                    'Lost calculator after math lecture.', '3 hr', Icons.calculate),
                _buildNotificationTile(
                    'Found AirPods near basketball court.', '5 hr', Icons.earbuds),
              ],
            ),
          ),
        ],
      ),


    );
  }

  // FILTER CHIP BUILDER
  Widget _buildFilterChip(String label) {
    final bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // NOTIFICATION TILE BUILDER
  Widget _buildNotificationTile(String text, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.grey[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Column(
            children: [
              Text(time,
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: 12)),
              const Icon(Icons.more_horiz, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}