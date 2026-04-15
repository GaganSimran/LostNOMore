import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final String selected;
  final Function(String) onItemTap;
//this widget its specifically for the side bar
  //for each item like dashboard
  //report and etc
  //it also chnages the color when u select it
  const AppSidebar({
    super.key,
    required this.selected,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: const Color(0xFF3D47FF),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.search, color: Colors.white, size: 40),
          const SizedBox(height: 10),
          const Text(
            "Lost & Found",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 30),
          //with icons next to it
          _item("Dashboard", Icons.dashboard),
          _item("Manage Posts", Icons.list_alt),
          _item("Reports", Icons.bar_chart),
          _item("Settings", Icons.settings),

          const Spacer(),
          //this is for the name downbelow with the avatar
          const ListTile(
            leading: CircleAvatar(backgroundColor: Colors.white24),
            title: Text("Admin", style: TextStyle(color: Colors.white)),
            subtitle: Text(
              "admin@mail.com",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
//if the item its selected change the color
  Widget _item(String title, IconData icon) {
    final isSelected = selected == title;

    return Container(
      color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: () => onItemTap(title),
      ),
    );
  }
}