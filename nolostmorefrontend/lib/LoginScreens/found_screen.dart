import 'package:flutter/material.dart';



class FoundScreen extends StatefulWidget {
  const FoundScreen({super.key});

  @override
  State<FoundScreen> createState() => _FoundScreenState();
}

class _FoundScreenState extends State<FoundScreen> {
  String selectedFilter = 'Last 24 hours'; // Track which filter is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Header Row: Profile and Search
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          icon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                'Find Items',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 1, color: Colors.grey),
              const Text(
                'Find item by unique ID number',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 10),

              // ID Input Field
              TextField(
                decoration: InputDecoration(
                  hintText: 'Unique ID number',
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Blue Action Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003CC0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Find my item',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 25.0),
                child: Center(
                  child: Text(
                    'OR',
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),

              const Text(
                'Find by posts',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 10),

              // Filter Buttons as ElevatedButtons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _filterButton('Last 24 hours'),
                  _filterButton('Last week'),
                  _filterButton('Last Month'),
                ],
              ),

              const SizedBox(height: 20),

              // Grid of items
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
                children: [
                  _itemCard('Set of keys', 'Pending', '3 hr ago', Icons.error_outline),
                  _itemCard('Wallet', 'Given to Security', '2 hr ago', Icons.check_box_outlined),
                ],
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar

    );
  }

  // Helper Widget for Filter Buttons
  Widget _filterButton(String text) {
    bool isSelected = selectedFilter == text;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              selectedFilter = text;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.black : Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Helper Widget for Item Cards
  Widget _itemCard(String title, String status, String time, IconData statusIcon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: NetworkImage('https://via.placeholder.com/150'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('• $title', style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Text('• Status: $status', style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Icon(statusIcon, size: 14, color: Colors.blue),
          ],
        ),
        Text('• Posted $time', style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}