import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_config.dart';
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
  final TextEditingController searchController = TextEditingController();

  List allItems = [];
  List filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final res = await http.get(Uri.parse(AppConfig.items));
    final data = jsonDecode(res.body);

    setState(() {
      allItems = data;
      filteredItems = data;
    });
  }

  void findItemById() {
    final input = idController.text.trim();

    final foundItem = allItems.firstWhere(
          (item) => item['item_code'] == input,
      orElse: () => null,
    );

    if (foundItem != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Item Found ")));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailScreen(item: foundItem),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Item Not Found ")));
    }
  }

  void onSearchChanged(String query) {
    final lower = query.toLowerCase();

    setState(() {
      filteredItems = allItems.where((item) {
        final title = (item['title'] ?? "").toString().toLowerCase();
        final code = (item['item_code'] ?? "").toString().toLowerCase();
        return title.contains(lower) || code.contains(lower);
      }).toList();
    });
  }

  void applyTimeFilter(String type) {
    setState(() {
      if (selectedFilter == type) {
        selectedFilter = '';
        filteredItems = allItems;
        return;
      }

      selectedFilter = type;
      final now = DateTime.now();

      filteredItems = allItems.where((item) {
        final rawDate = item['created_at'];
        if (rawDate == null) return false;

        final itemDate = DateTime.tryParse(rawDate.toString());
        if (itemDate == null) return false;

        if (type == 'Last 24 hours') {
          return now.difference(itemDate).inHours <= 24;
        } else if (type == 'Last week') {
          return now.difference(itemDate).inDays <= 7;
        } else if (type == 'Last Month') {
          return now.difference(itemDate).inDays <= 30;
        }

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: allItems.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
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
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        decoration: const InputDecoration(
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
                style:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const Text(
                'Find item by unique ID number',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 10),
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: findItemById,
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
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: Text(
                    'OR',
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              const Text(
                'Find by posts',
                style:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    _filterButton('Last 24 hours'),
                    _filterButton('Last week'),
                    _filterButton('Last Month'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredItems.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final imageUrl = item['image_url'] ?? "";
                  final hasImage =
                      imageUrl.isNotEmpty && imageUrl.startsWith("http");

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ItemDetailScreen(item: item),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 130,
                                  width: double.infinity,
                                  child: hasImage
                                      ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                      : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image),
                                  ),
                                ),
                                Container(
                                  height: 130,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.55),
                                        Colors.transparent
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: item['status'] == "approved"
                                          ? Colors.green
                                          : Colors.orange,
                                      borderRadius:
                                      BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      item['status'] ?? "pending",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(12, 12, 12, 10),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.label,
                                        size: 12,
                                        color: Colors.blue),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        item['category'] ?? "",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterButton(String text) {
    bool isSelected = selectedFilter == text;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => applyTimeFilter(text),
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isSelected ? Colors.orange : Colors.black87,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}