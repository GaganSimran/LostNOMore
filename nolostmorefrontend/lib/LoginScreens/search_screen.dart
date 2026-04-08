import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildHeader(),
              const SizedBox(height: 25),
              const Text(
                "Find By Categories",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text("Easy finds with categories", style: TextStyle(color: Colors.grey)),
              const Divider(),
              const SizedBox(height: 15),
              _buildCategoryGrid(),
              const SizedBox(height: 30),
              const Text(
                "Posts",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildTimeFilters(),
              const SizedBox(height: 20),
              _buildPostList(),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'name': 'Wallets', 'color': Colors.orange[700], 'icon': Icons.wallet},
      {'name': 'Keys', 'color': Colors.orange[700], 'icon': Icons.vpn_key},
      {'name': 'Air buds', 'color': Colors.orange[700], 'icon': Icons.headphones},
      {'name': 'ID cards', 'color': Colors.orange[700], 'icon': Icons.badge},
      {'name': 'Books', 'color': Colors.orange[700], 'icon': Icons.book},
      {'name': 'Other', 'color': Colors.orange[700], 'icon': Icons.emoji_people},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: categories[index]['color'] as Color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Icon(categories[index]['icon'] as IconData, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                categories[index]['name'] as String,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeFilters() {
    final filters = ["Last 24 hours", "Last week", "Last month"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: filters.map((filter) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(filter, style: const TextStyle(color: Colors.white, fontSize: 12)),
        );
      }).toList(),
    );
  }

  Widget _buildPostList() {
    final posts = [
      {"title": "Set of keys", "status": "Pending", "time": "3 hr ago", "color": Colors.red},
      {"title": "Wallet", "status": "Given to Security", "time": "2 hr ago", "color": Colors.green},
    ];

    return Column(
      children: posts.map((post) {
        final Color statusColor = post["color"] as Color;

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post["title"] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text("Status: ${post["status"] as String}", style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 5),
                        Icon(
                          statusColor == Colors.green ? Icons.check_box : Icons.info_outline,
                          size: 14,
                          color: statusColor,
                        ),
                      ],
                    ),
                    Text("Posted ${post["time"] as String}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }


}