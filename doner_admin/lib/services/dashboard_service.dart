import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_stats.dart';
import '../config/app_config.dart';
import 'token_storage.dart';

class DashboardService {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<DashboardStats> getStats() async {
    try {
      final token = await _tokenStorage.getToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/admin/dashboard'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return DashboardStats.fromJson(data);
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard stats: $e');
    }
  }
}
