import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/order.dart';
import '../services/api_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  final ApiService apiService;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.apiService,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Order _order;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final updatedOrder = await widget.apiService.updateOrderStatus(
        _order.id,
        newStatus,
      );
      setState(() {
        _order = updatedOrder;
        _isUpdating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Статус изменён на: ${_getStatusText(newStatus)}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Новый';
      case 'accepted':
        return 'Принят';
      case 'preparing':
        return 'Готовится';
      case 'ready':
        return 'Готов';
      case 'completed':
        return 'Завершён';
      default:
        return status;
    }
  }

  void _callPhone(String? phone) {
    if (phone != null && phone.isNotEmpty) {
      // Удаляем все нецифровые символы кроме +
      final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
      // Добавляем tel: для Android
      final uri = Uri.parse('tel:$cleanPhone');
      // Можно использовать url_launcher пакет для более надёжной работы
      // Пока используем простой способ
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_order);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Заказ #${_order.id}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black87,
        ),
      body: _isUpdating
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Статус заказа
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Статус заказа',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getStatusText(_order.status),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Блюда
                  const Text(
                    'Блюда',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._order.items.map((item) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.price.toStringAsFixed(0)} ₽ × ${item.quantity}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${(item.price * item.quantity).toStringAsFixed(0)} ₽',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),
                  Divider(thickness: 2),
                  const SizedBox(height: 16),

                  // Итого
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Итого:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_order.total.toStringAsFixed(0)} ₽',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Контактная информация
                  if (_order.phone != null || _order.address != null) ...[
                    const Text(
                      'Контактная информация',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_order.phone != null)
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.phone, size: 28),
                          title: const Text(
                            'Телефон',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            _order.phone!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.phone, size: 32),
                            color: Colors.green,
                            onPressed: () => _callPhone(_order.phone),
                          ),
                        ),
                      ),
                    if (_order.address != null)
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.location_on, size: 28),
                          title: const Text(
                            'Адрес',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            _order.address!,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],

                  // Комментарий
                  if (_order.comment != null && _order.comment!.isNotEmpty) ...[
                    const Text(
                      'Комментарий',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _order.comment!,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Кнопки изменения статуса
                  const Text(
                    'Изменить статус',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Принять
                  if (_order.status.toLowerCase() == 'pending')
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: _isUpdating
                            ? null
                            : () => _updateStatus('accepted'),
                        icon: const Icon(Icons.check_circle, size: 28),
                        label: const Text(
                          'Принять',
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                  // Готовится
                  if (_order.status.toLowerCase() == 'accepted')
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: _isUpdating
                            ? null
                            : () => _updateStatus('preparing'),
                        icon: const Icon(Icons.restaurant, size: 28),
                        label: const Text(
                          'Готовится',
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                  // Готов
                  if (_order.status.toLowerCase() == 'preparing')
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: _isUpdating
                            ? null
                            : () => _updateStatus('ready'),
                        icon: const Icon(Icons.done_all, size: 28),
                        label: const Text(
                          'Готов',
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
      ),
    );
  }
}
