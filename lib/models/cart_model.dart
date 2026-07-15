// lib/models/cart_model.dart

import 'product_model.dart'; // We need Product here

class CartItem {
  final String id;       // Unique ID for this cart entry
  final Product product; // The actual farm product
  int quantity;          // How many units the user wants

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  // Calculated property — price x quantity
  // e.g., Rice at 5000 x 3 bags = 15000
  double get totalPrice => product.pricePerUnit * quantity;
}
