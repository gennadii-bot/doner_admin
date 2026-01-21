class Order {
  final int id;
  final double total;
  final String status;
  final DateTime createdAt;
  final String? address;
  final String? phone;
  final String? comment;
  final List<OrderItem> items;
  final bool isNew;

  Order({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
    this.address,
    this.phone,
    this.comment,
    required this.items,
    this.isNew = false,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      comment: json['comment'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      isNew: json['is_new'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total': total,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'address': address,
      'phone': phone,
      'comment': comment,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  Order copyWith({
    int? id,
    double? total,
    String? status,
    DateTime? createdAt,
    String? address,
    String? phone,
    String? comment,
    List<OrderItem>? items,
    bool? isNew,
  }) {
    return Order(
      id: id ?? this.id,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      comment: comment ?? this.comment,
      items: items ?? this.items,
      isNew: isNew ?? this.isNew,
    );
  }
}

class OrderItem {
  final int id;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
