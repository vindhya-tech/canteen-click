// lib/services/menu_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuService {
  static const String baseUrl = 'http://192.168.252.228:5000/api';

  static Future<List<Map<String, dynamic>>> getMenuItems() async {
    final response = await http.get(Uri.parse('$baseUrl/menu'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load menu');
    }
  }

  static Future<void> addMenuItem(String name, double price) async {
    final response = await http.post(
      Uri.parse('$baseUrl/menu'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'price': price}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add menu item');
    }
  }

  static Future<void> updateAvailability(String id, bool isAvailable) async {
    final response = await http.put(
      Uri.parse('$baseUrl/menu/$id/availability'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'isAvailable': isAvailable}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update availability');
    }
  }
}
