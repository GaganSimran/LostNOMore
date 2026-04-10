import 'package:flutter/material.dart';

class ItemDetailScreen extends StatelessWidget {
  final Map item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Item detail",
            style: TextStyle(color: Colors.black)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                image: item['image_url'] != ""
                    ? DecorationImage(
                  image: (item['image_url'] != null && item['image_url'].toString().startsWith("http"))
                      ? NetworkImage(item['image_url'])
                      : const NetworkImage("https://via.placeholder.com/150"),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: item['image_url'] == ""
                  ? const Icon(Icons.image, size: 50)
                  : null,
            ),

            const SizedBox(height: 20),

            Text(
              item['title'] ?? "",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 5),

            Text(item['description'] ?? ""),

            const SizedBox(height: 15),

            const Text("Status",
                style: TextStyle(fontWeight: FontWeight.bold)),

            Text(item['status'] ?? "pending"),

            const SizedBox(height: 15),

            const Text("Item ID",
                style: TextStyle(fontWeight: FontWeight.bold)),

            Text(item['item_code'] ?? ""),

          ],
        ),
      ),
    );
  }
}