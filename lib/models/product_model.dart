// lib/models/product_model.dart

class Product {
  final String id;
  final String name;
  final String category;
  final double pricePerUnit;
  final String unit;
  final String imageUrl;
  final String? farmerId;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePerUnit,
    required this.unit,
    required this.imageUrl,
    this.farmerId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] as String,
      category: json['category'] as String,
      pricePerUnit: (json['price_per_unit'] as num).toDouble(),
      unit: json['unit'] as String,
      imageUrl: json['image_url'] as String? ?? '',
      farmerId: json['farmer_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'price_per_unit': pricePerUnit,
      'unit': unit,
      'image_url': imageUrl,
      'farmer_id': farmerId,
    };
  }
}
