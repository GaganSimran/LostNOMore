import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/report_model.dart';

class ReportService {
  static const String baseUrl = 'https://nolostmore-backend.onrender.com';

  static Future<List<ReportModel>> fetchReports() async {
    final response = await http.get(Uri.parse('$baseUrl/reports'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => ReportModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }
}