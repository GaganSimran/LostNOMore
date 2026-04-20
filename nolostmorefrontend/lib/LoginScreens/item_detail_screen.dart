import 'package:flutter/material.dart';

class ItemDetailScreen extends StatelessWidget {
  final Map item;

  const ItemDetailScreen({super.key, required this.item});

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = (item['status'] ?? "pending").toString().toLowerCase();

    IconData statusIcon = Icons.info_outline;
    Color statusColor = Colors.blue;

    if (status == "approved") {
      statusIcon = Icons.check_circle;
      statusColor = Colors.green;
    } else if (status == "pending") {
      statusIcon = Icons.cancel;
      statusColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
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

            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
                image: item['image_url'] != ""
                    ? DecorationImage(
                  image: (item['image_url'] != null &&
                      item['image_url'].toString().startsWith("http"))
                      ? NetworkImage(item['image_url'])
                      : const NetworkImage(
                      "https://via.placeholder.com/150"),
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

            _sectionTitle("Description"),
            _card(
              Text(
                item['description'] ?? "",
                style: const TextStyle(height: 1.5),
              ),
            ),

            _sectionTitle("Status"),
            _card(
              Row(
                children: [
                  Icon(statusIcon, size: 18, color: statusColor),
                  const SizedBox(width: 8),
                  Text(
                    item['status'] ?? "pending",
                    style: TextStyle(color: statusColor),
                  ),
                ],
              ),
            ),

            _sectionTitle("Item ID"),
            _card(
              Row(
                children: [
                  const Icon(Icons.qr_code, size: 18, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(item['item_code'] ?? ""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}