class MenuItem {
  final int id;
  final String name;
  final double price;
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      isAvailable: json['is_available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'is_available': isAvailable,
    };
  }

  MenuItem copyWith({
    int? id,
    String? name,
    double? price,
    bool? isAvailable,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
