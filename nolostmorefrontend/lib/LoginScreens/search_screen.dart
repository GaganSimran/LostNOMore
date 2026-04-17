import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nolostmorefrontend/LoginScreens/app_config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'item_detail_screen.dart';

class SearchScreen extends StatefulWidget {

  final String profileImage;
  const SearchScreen({super.key, required this.profileImage});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  late Future<List> itemsFuture;

  List allItems = [];
  List filteredItems = [];

  List<String> searchHistory = [];

  TextEditingController searchController = TextEditingController();

  String selectedFilter = "";
  String selectedCategory = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await loadItems();
    await loadHistory();
  }

  Future<void> loadItems() async {
    final res = await http.get(Uri.parse(AppConfig.items));
    final data = jsonDecode(res.body);

    setState(() {
      allItems = data;
      filteredItems = data;
    });
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

  Future<void> saveToHistory(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    searchHistory.remove(query);
    searchHistory.insert(0, query);

    await prefs.setStringList("search_history", searchHistory);
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      searchHistory = prefs.getStringList("search_history") ?? [];
    });
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("search_history");

    setState(() {
      searchHistory.clear();
    });
  }

  void applyTimeFilter(String type) {
    setState(() {
      if (selectedFilter == type) {
        selectedFilter = "";
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

        if (type == "24h") {
          return now.difference(itemDate).inHours <= 24;
        } else if (type == "week") {
          return now.difference(itemDate).inDays <= 7;
        } else if (type == "month") {
          return now.difference(itemDate).inDays <= 30;
        }

        return true;
      }).toList();
    });
  }

  void applyCategoryFilter(String category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = "";
        filteredItems = allItems;
        return;
      }

      selectedCategory = category;

      filteredItems = allItems.where((item) {
        final itemCategory = (item['category'] ?? "").toString();
        return itemCategory.toLowerCase() == category.toLowerCase();
      }).toList();
    });
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

              if (searchController.text.isEmpty && searchHistory.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recent Searches",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: searchHistory.map((item) {
                        return ActionChip(
                          label: Text(item),
                          onPressed: () {
                            searchController.text = item;
                            onSearchChanged(item);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              Builder(
                builder: (context) {

                  final items = filteredItems;

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
            controller: searchController,
            onChanged: onSearchChanged,
            onSubmitted: (value) {
              saveToHistory(value);
            },
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
      {'name': 'AirPods', 'color': Colors.orange[700], 'icon': Icons.headphones},
      {'name': 'ID Cards', 'color': Colors.orange[700], 'icon': Icons.badge},
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
        final categoryName = categories[index]['name'] as String;
        final isSelected = selectedCategory == categoryName;

        return GestureDetector(
          onTap: () => applyCategoryFilter(categoryName),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.deepOrange
                  : categories[index]['color'] as Color,
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
          ),
        );
      },
    );
  }

  Widget _buildTimeFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _filterTab("Last 24 hours", "24h"),
        _filterTab("Last week", "week"),
        _filterTab("Last month", "month"),
      ],
    );
  }

  Widget _filterTab(String label, String type) {
    final isSelected = selectedFilter == type;

    return GestureDetector(
      onTap: () => applyTimeFilter(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}