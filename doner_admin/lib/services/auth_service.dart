import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class AuthService {
  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.loginEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['access_token'] as String;
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        final errorMessage = errorData['detail'] as String? ?? 
                           errorData['message'] as String? ?? 
                           'Ошибка авторизации: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Ошибка при выполнении запроса: $e');
    }
  }
}
