import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'search_screen.dart';
import 'lost_screen.dart';
import 'found_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';
import 'item_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late Future<List> itemsFuture;

  double _brightness = 1.0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    itemsFuture = fetchItems();
  }

  Future<List> fetchItems() async {
    final res = await http.get(
      Uri.parse("http://192.168.2.27:3000/items"),
    );

    print("FETCH STATUS: ${res.statusCode}");
    print("FETCH BODY: ${res.body}");

    return jsonDecode(res.body);
  }

  void refreshItems() {
    setState(() {
      itemsFuture = fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _homeContent(),
      const SearchScreen(),
      const SizedBox(),
      NotificationScreen(username: widget.username),
      SettingsScreen(
        username: widget.username,
        brightness: _brightness,
        isDarkMode: _isDarkMode,
        onBrightnessChanged: (val) {
          setState(() => _brightness = val);
        },
        onThemeChanged: (val) {
          setState(() => _isDarkMode = val);
        },
      ),
    ];

    return Stack(
      children: [
        Theme(
          data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
          child: Scaffold(
            body: _selectedIndex == 2
                ? const SizedBox()
                : screens[_selectedIndex],

            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.blue[900],
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _selectedIndex,

              onTap: (index) {
                if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LostScreen()),
                  ).then((_) {
                    refreshItems();
                  });
                } else {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              },

              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
                BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: "Post"),
                BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: "Notifications"),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
              ],
            ),
          ),
        ),

        // 🔥 SMOOTH BRIGHTNESS (FIXED)
        IgnorePointer(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: 1 - _brightness,
            child: Container(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _homeContent() {
    return SafeArea(
      child: FutureBuilder(
        future: itemsFuture,
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data as List;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Hello, ${widget.username}",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  "Discover What's happening on Campus",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),

                const Divider(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _buildActionButton(
                        context,
                        question: "Missing something?",
                        label: "Lost",
                        color: Colors.red[900]!,
                        navigateTo: const LostScreen(),
                      ),
                      const SizedBox(height: 20),
                      _buildActionButton(
                        context,
                        question: "Found something?",
                        label: "Found",
                        color: Colors.green[800]!,
                        navigateTo: const FoundScreen(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Text("Recent posts",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                const Divider(),

                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.3,
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
                            height: 100,
                            width: double.infinity,
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

                          const SizedBox(height: 5),

                          Text("• ${item['title'] ?? ""}"),
                          Text("• Status: ${item['status'] ?? "pending"}"),
                          Text("• ${item['category'] ?? ""}"),
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
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required String question,
        required String label,
        required Color color,
        required Widget navigateTo,
      }) {
    return Column(
      children: [
        Text(question),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => navigateTo),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: color),
          child: Text(label),
        ),
      ],
    );
  }
}