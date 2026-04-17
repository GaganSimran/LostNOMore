import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'app_config.dart';

class EditProfileScreen extends StatefulWidget {
  final int userId;
  final String currentName;
  final String currentBio;
  final String currentImage;

  const EditProfileScreen({
    super.key,
    required this.userId,
    required this.currentName,
    required this.currentBio,
    required this.currentImage,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController bioController;

  XFile? image;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    bioController = TextEditingController(text: widget.currentBio);
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => image = picked);
    }
  }

  Future<String> uploadToCloudinary() async {
    if (image == null) return widget.currentImage;

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
    return data['secure_url'] ?? widget.currentImage;
  }

  Future<void> updateProfile() async {
    final imageUrl = await uploadToCloudinary();

    final response = await http.put(
      Uri.parse("${AppConfig.users}/${widget.userId}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
        "bio": bioController.text,
        "profile_image": imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, {
        "name": nameController.text,
        "bio": bioController.text,
        "image": imageUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? displayImage;

    if (image != null) {
      displayImage = FileImage(File(image!.path));
    } else if (widget.currentImage.isNotEmpty) {
      displayImage = NetworkImage(widget.currentImage);
    } else {
      displayImage = null;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: displayImage,
                      backgroundColor: Colors.grey[200],
                      child: displayImage == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: bioController,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      labelText: "Bio",
                      prefixIcon: const Icon(Icons.info_outline),
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}