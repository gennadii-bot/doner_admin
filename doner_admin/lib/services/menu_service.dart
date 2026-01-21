import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_item.dart';
import '../config/app_config.dart';
import 'token_storage.dart';

class MenuService {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<String?> _getAuthToken() async {
    return await _tokenStorage.getToken();
  }

  Future<List<MenuItem>> getMenu() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/admin/menu'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MenuItem.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load menu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching menu: $e');
    }
  }

  Future<MenuItem> createMenuItem(String name, double price, bool isAvailable) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/admin/menu'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'price': price,
          'is_available': isAvailable,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return MenuItem.fromJson(data);
      } else {
        throw Exception('Failed to create menu item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating menu item: $e');
    }
  }

  Future<MenuItem> updateMenuItem(int id, String name, double price, bool isAvailable) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}/admin/menu/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'price': price,
          'is_available': isAvailable,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return MenuItem.fromJson(data);
      } else {
        throw Exception('Failed to update menu item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating menu item: $e');
    }
  }

  Future<void> deleteMenuItem(int id) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http.delete(
        Uri.parse('${AppConfig.baseUrl}/admin/menu/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete menu item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting menu item: $e');
    }
  }
}
