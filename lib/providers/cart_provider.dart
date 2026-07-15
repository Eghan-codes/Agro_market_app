// lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {

  // Private map: productId -> CartItem
  // Using a Map so we can quickly find items by product ID
  final Map<String, CartItem> _items = {};

  // PUBLIC GETTERS — screens read these
  
  // Returns a copy of the cart (so outside code can't edit it directly)
  Map<String, CartItem> get items => {..._items};

  // How many DIFFERENT products are in the cart (not total quantity)
  int get itemCount => _items.length;

  // Total price of everything in the cart combined
  double get totalAmount {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  // METHODS — screens call these to change the cart

  // Add a product to cart OR increase its quantity if already there
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      // Product already in cart — just bump the quantity
      _items[product.id]!.quantity += 1;
    } else {
      // New product — create a fresh CartItem
      _items[product.id] = CartItem(
        id: DateTime.now().toString(),
        product: product,
        quantity: 1,
      );
    }
    notifyListeners(); // Tell all listening screens to rebuild
  }

  // Remove a product completely from the cart
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Decrease quantity by 1, remove if it reaches 0
  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      // Quantity is 1 — removing it entirely
      _items.remove(productId);
    }
    notifyListeners();
  }

  // Increase quantity by 1
  void increaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;
    _items[productId]!.quantity += 1;
    notifyListeners();
  }

  // Wipe the entire cart (called after placing order)
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
