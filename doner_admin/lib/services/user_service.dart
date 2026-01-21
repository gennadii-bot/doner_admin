import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../config/app_config.dart';
import 'token_storage.dart';

class UserService {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<String?> _getAuthToken() async {
    return await _tokenStorage.getToken();
  }

  Future<List<UserModel>> getUsers() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/admin/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Future<void> blockUser(int id) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http.patch(
        Uri.parse('${AppConfig.baseUrl}/admin/users/$id/block'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to block user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error blocking user: $e');
    }
  }

  Future<void> unblockUser(int id) async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http.patch(
        Uri.parse('${AppConfig.baseUrl}/admin/users/$id/unblock'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to unblock user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error unblocking user: $e');
    }
  }
}
