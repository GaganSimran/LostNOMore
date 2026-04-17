import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:nolostmorefrontend/LoginScreens/app_config.dart';
import 'dart:convert';

import 'search_screen.dart';
import 'lost_screen.dart';
import 'found_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';
import 'item_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final int userId;
  final String profileImage;
  final String bio;

  const HomeScreen({
    super.key,
    required this.username,
    required this.userId,
    required this.profileImage,
    required this.bio,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late Future<List> itemsFuture;

  double _brightness = 1.0;
  bool _isDarkMode = false;

  late String _profileImage;
  late String _username;
  late String _bio;

  @override
  void initState() {
    super.initState();
    itemsFuture = fetchItems();

    _profileImage = widget.profileImage;
    _username = widget.username;
    _bio = widget.bio;
  }

  Future<List> fetchItems() async {
    final res = await http.get(Uri.parse(AppConfig.items));
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
      SearchScreen(profileImage: _profileImage),
      const SizedBox(),
      NotificationScreen(
        username: _username,
        profileImage: _profileImage,
      ),
      SettingsScreen(
        username: _username,
        brightness: _brightness,
        bio: _bio,
        profileImage: _profileImage,
        userId: widget.userId,
        isDarkMode: _isDarkMode,
        onBrightnessChanged: (val) {
          setState(() => _brightness = val);
        },
        onThemeChanged: (val) {
          setState(() => _isDarkMode = val);
        },
        onProfileUpdated: (data) {
          setState(() {
            _username = data["name"];
            _bio = data["bio"];
            _profileImage = data["image"];
          });
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
                    MaterialPageRoute(
                      builder: (_) => LostScreen(username: _username),
                    ),
                  ).then((_) => refreshItems());
                } else {
                  setState(() => _selectedIndex = index);
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

                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: _profileImage.isNotEmpty
                          ? NetworkImage(_profileImage)
                          : null,
                      child: _profileImage.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, $_username",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Discover What's happening on Campus",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                        color: Colors.red,
                        navigateTo: LostScreen(username: _username),
                      ),
                      const SizedBox(height: 20),
                      _buildActionButton(
                        context,
                        question: "Found something?",
                        label: "Found",
                        color: Colors.green,
                        navigateTo: FoundScreen(profileImage: _profileImage),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                const Text(
                  "Recent posts",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const Divider(),
                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    final imageUrl = item['image_url'] ?? "";
                    final hasImage =
                        imageUrl.isNotEmpty && imageUrl.startsWith("http");

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
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: item['status'] == "approved"
                                            ? Colors.green
                                            : Colors.orange,
                                        borderRadius: BorderRadius.circular(30),
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
                              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      const Icon(Icons.label, size: 12, color: Colors.blue),
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
          style: ElevatedButton.styleFrom(
              backgroundColor: color, foregroundColor: Colors.white70),
          child: Text(label),
        ),
      ],
    );
  }
}