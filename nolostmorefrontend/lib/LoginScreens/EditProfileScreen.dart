import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

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
      Uri.parse("http://192.168.2.27:3000/users/${widget.userId}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
        "bio": bioController.text,
        "profile_image": imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = image != null
        ? Image.network(image!.path).image
        : (widget.currentImage.isNotEmpty
        ? NetworkImage(widget.currentImage)
        : null);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: displayImage,
                child: displayImage == null
                    ? const Icon(Icons.camera_alt)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: "Bio"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: updateProfile,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}