import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nolostmorefrontend/LoginScreens/app_config.dart';
import 'dart:convert';

import 'item_detail_screen.dart';

class SearchScreen extends StatefulWidget {

  final String profileImage;
  const SearchScreen({super.key, required this.profileImage});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  late Future<List> itemsFuture;

  @override
  void initState() {
    super.initState();
    itemsFuture = fetchItems();
  }

  Future<List> fetchItems() async {
    final res = await http.get(
      Uri.parse(AppConfig.items),
    );

    return jsonDecode(res.body);
  }

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

              const Text(
                "Easy finds with categories",
                style: TextStyle(color: Colors.grey),
              ),

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

              // 🔥 REAL POSTS FROM BACKEND
              FutureBuilder(
                future: itemsFuture,
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final items = snapshot.data as List;

                  return Column(
                    children: items.map((item) {

                      final imageUrl = item['image_url'] ?? "";

                      final hasImage = imageUrl.isNotEmpty &&
                          imageUrl.toString().startsWith("http");

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ItemDetailScreen(item: item),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // IMAGE
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[300],
                                  image: hasImage
                                      ? DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: !hasImage
                                    ? const Icon(Icons.image)
                                    : null,
                              ),

                              const SizedBox(width: 15),

                              // TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      item['title'] ?? "",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          "Status: ${item['status'] ?? "pending"}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(
                                          item['status'] == "approved"
                                              ? Icons.check_box
                                              : Icons.info_outline,
                                          size: 14,
                                          color: item['status'] == "approved"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ],
                                    ),

                                    Text(
                                      "Item ID: ${item['item_code'] ?? ""}",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: widget.profileImage.isNotEmpty
              ? NetworkImage(widget.profileImage)
              : null,
          child: widget.profileImage.isEmpty
              ? const Icon(Icons.person)
              : null,
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
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
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
          child: Text(
            filter,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        );
      }).toList(),
    );
  }
}