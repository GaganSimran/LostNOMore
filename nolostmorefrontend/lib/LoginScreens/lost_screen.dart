import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class LostScreen extends StatefulWidget {
  const LostScreen({super.key});

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

    print("CLOUDINARY RESPONSE: ${res.body}");

    final data = jsonDecode(res.body);
    return data['secure_url'] ?? "";
  }

  Future<void> submitItem() async {
    final imageUrl = await uploadToCloudinary();

    print("IMAGE URL: $imageUrl");

    final response = await http.post(
      Uri.parse("http://192.168.2.27:3000/items"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": 1,
        "item_code": "ITEM${DateTime.now().millisecondsSinceEpoch}",
        "title": titleController.text,
        "description": descController.text,
        "category": selectedCategory,
        "location": locationController.text,
        "image_url": imageUrl,
        "type": "lost"
      }),
    );

    print("ITEM STATUS: ${response.statusCode}");
    print("ITEM BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text("Report Lost Item",
            style: TextStyle(color: Colors.black)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text('Upload Image'),
            const SizedBox(height: 8),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    image == null
                        ? const Icon(Icons.cloud_upload_outlined, size: 40)
                        : Text(image!.name),
                    const SizedBox(height: 10),
                    const Text('Tap to upload image'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _input(titleController, 'Item name'),
            _input(descController, 'Description'),

            const Text("Category"),
            DropdownButtonFormField(
              value: selectedCategory,
              items: categories.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (val) => setState(() => selectedCategory = val.toString()),
            ),

            const SizedBox(height: 15),

            _input(locationController, 'Location'),

            const SizedBox(height: 10),

            ListTile(
              title: Text(selectedDate == null
                  ? "Select Date"
                  : selectedDate.toString().split(" ")[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: pickDate,
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: submitItem,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                    child: const Text('Submit report'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.blueGrey[100],
        ),
      ),
    );
  }
}