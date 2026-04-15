import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'item_detail_screen.dart';

class FoundScreen extends StatefulWidget {
  final String profileImage;
  const FoundScreen({super.key, required this.profileImage});

  @override
  State<FoundScreen> createState() => _FoundScreenState();
}

class _FoundScreenState extends State<FoundScreen> {
  String selectedFilter = 'Last 24 hours';

  final TextEditingController idController = TextEditingController();

  late Future<List> itemsFuture;

  @override
  void initState() {
    super.initState();
    itemsFuture = fetchItems();
  }

  Future<List> fetchItems() async {
    final res = await http.get(
      Uri.parse("http://192.168.2.27:3000/items"),
    );

    return jsonDecode(res.body);
  }

  // SEARCH BY ITEM CODE
  void findItemById(List items) {
    final input = idController.text.trim();

    final foundItem = items.firstWhere(
          (item) => item['item_code'] == input,
      orElse: () => null,
    );

    if (foundItem != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item Found ✅")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailScreen(item: foundItem),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item Not Found ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: FutureBuilder(
          future: itemsFuture,
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = snapshot.data as List;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 10),

                  // HEADER
                  Row(
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

                  const Divider(),

                  const Text(
                    'Find item by unique ID number',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  // INPUT FIELD
                  TextField(
                    controller: idController,
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

                  //  BUTTON SEARCH
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => findItemById(items),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003CC0),
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

                  const Divider(),

                  const SizedBox(height: 10),

                  // FILTERS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _filterButton('Last 24 hours'),
                      _filterButton('Last week'),
                      _filterButton('Last Month'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  //  REAL POSTS (LIKE HOME SCREEN)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
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

                            const SizedBox(height: 8),

                            Text('• ${item['title'] ?? ""}',
                                style: const TextStyle(fontWeight: FontWeight.bold)),

                            Text('• Status: ${item['status'] ?? ""}',
                                style: const TextStyle(fontSize: 12)),

                            Text('• ${item['category'] ?? ""}',
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

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
          ),
          child: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ),
    );
  }
}