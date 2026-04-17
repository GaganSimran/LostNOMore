import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:nolostmorefrontend/LoginScreens/app_config.dart';

import 'notification_service.dart';

class LostScreen extends StatefulWidget {
  final String username;
  const LostScreen({super.key, required this.username});

  @override
  State<LostScreen> createState() => _LostScreenState();
}

class _LostScreenState extends State<LostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String selectedCategory = "Wallet";
  DateTime? selectedDate;

  XFile? image;

  final List<String> categories = [
    "Wallet", "AirPods", "ID Card", "Keys", "Books", "Other"
  ];

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => image = picked);
    }
  }

  Future<String> uploadToCloudinary() async {
    if (image == null) return "";

    final url = Uri.parse("https://api.cloudinary.com/v1_1/dg6idtfrn/image/upload");

    var request = http.MultipartRequest("POST", url);
    request.fields['upload_preset'] = "ml_default";

    request.files.add(
      await http.MultipartFile.fromBytes(
        'file',
        await image!.readAsBytes(),
        filename: image!.name,
      ),
    );

    var response = await request.send();
    var res = await http.Response.fromStream(response);

    final data = jsonDecode(res.body);
    return data['secure_url'] ?? "";
  }

  Future<void> submitItem() async {
    final imageUrl = await uploadToCloudinary();

    final itemCode = "ITEM${DateTime.now().millisecondsSinceEpoch}";

    final response = await http.post(
      Uri.parse(AppConfig.items),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": 1,
        "item_code": itemCode,
        "title": titleController.text,
        "description": descController.text,
        "category": selectedCategory,
        "location": locationController.text,
        "image_url": imageUrl,
        "type": "lost"
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      NotificationService.addNotification(
        "Hey ${widget.username}, your item has been posted successfully.\nItem ID: $itemCode",
      );

      Navigator.pop(context);
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.blue.shade100),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.blue.shade100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Report Lost Item",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Upload Image",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      image == null
                          ? Icons.cloud_upload_outlined
                          : Icons.check_circle,
                      size: 45,
                      color: image == null ? Colors.blue : Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      image == null ? "Tap to upload image" : image!.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: titleController,
              decoration: _inputStyle("Item Name"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: descController,
              maxLines: 3,
              decoration: _inputStyle("Description"),
            ),

            const SizedBox(height: 15),

            const Text(
              "Category",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: selectedCategory,
                  isExpanded: true,
                  items: categories.map((c) {
                    return DropdownMenuItem(value: c, child: Text(c));
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => selectedCategory = val.toString()),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: locationController,
              decoration: _inputStyle("Location"),
            ),

            const SizedBox(height: 15),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: ListTile(
                title: Text(
                  selectedDate == null
                      ? "Select Date"
                      : selectedDate.toString().split(" ")[0],
                ),
                trailing: const Icon(Icons.calendar_today, color: Colors.blue),
                onTap: pickDate,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      elevation: 0,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    onPressed: submitItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Submit Report"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}