class FunkoPop {
  final String id;
  final String name;
  final String category;
  final double price;
  final int quantity;

  FunkoPop({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
  });

  factory FunkoPop.fromJson(Map<String, dynamic> json) {
    return FunkoPop(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'quantity': quantity,
    };
  }
}
