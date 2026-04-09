// report_lost_item_screen.dart
import 'package:flutter/material.dart';

class ReportLostItemScreen extends StatelessWidget {
  const ReportLostItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text(
          "Report Lost Item",
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Icon(Icons.signal_cellular_alt, color: Colors.black, size: 18),
          SizedBox(width: 5),
          Icon(Icons.wifi, color: Colors.black, size: 18),
          SizedBox(width: 5),
          Icon(Icons.battery_full, color: Colors.black, size: 18),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Section
            const Text(
              'Upload Image',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'Choose a file or drag & drop it here\nJPEG, PNG, PDF formats, up to 6MB',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    child: const Text('Browse File'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Input Fields
            _buildInputField('Item name', 'Enter item name'),
            _buildInputField('Description', 'Enter description'),
            _buildInputField('Category', 'Select category'),
            _buildInputField('Add location', 'Where did you see this item last?'),
            _buildInputField('Date', 'MM-DD-YYYY'),

            const SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel button goes back
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Submit action logic goes here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Report Submitted!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Submit report', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100), // Space for Bottom Nav
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Input Field Builder
  Widget _buildInputField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.blueGrey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Navigation
  Widget _buildBottomNav() {
    return Container(
      color: Colors.blue[900],
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.search, color: Colors.white),
          Icon(Icons.add_box, color: Colors.white),
          Icon(Icons.notifications, color: Colors.white),
          Icon(Icons.settings, color: Colors.white),
        ],
      ),
    );
  }
}

// To test this screen, run this file as main.dart like:
// void main() => runApp(MaterialApp(home: const ReportLostItemScreen()));