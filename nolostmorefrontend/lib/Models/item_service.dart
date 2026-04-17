import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/item_model.dart';

class ItemService {
  static const String baseUrl = 'https://nolostmore-backend.onrender.com';

  static Future<List<Item>> fetchItems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/items'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items: ${response.body}');
    }
  }

  static Future<void> approveItem(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/items/$id/approve'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve item: ${response.body}');
    }
  }


  static Future<void> updateItemStatus(int id, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/items/$id/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update status');
    }
  }
  static Future<void> deleteItem(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/items/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to deny item: ${response.body}');
    }
  }
}