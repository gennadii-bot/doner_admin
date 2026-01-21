import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../config/app_config.dart';

class ApiService {
  static String get baseUrl => AppConfig.baseUrl;

  Future<List<Order>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Order.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

  Future<Order> updateOrderStatus(int orderId, String status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Order.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating order: $e');
    }
  }
}
