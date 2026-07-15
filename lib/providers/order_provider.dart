import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';
import '../services/order_service.dart';
import '../services/auth_service.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => [..._orders];
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    final user = AuthService.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    _orders = await OrderService().fetchBuyerOrders(user.id);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> placeOrder(List<CartItem> cartItems, double total) async {
    final user = AuthService.currentUser;
    if (user == null) return false;

    final newOrder = OrderModel(
      orderId: 'AGM-${DateTime.now().millisecondsSinceEpoch}',
      items: cartItems,
      totalAmount: total,
      orderDate: DateTime.now(),
      buyerId: user.id,
    );

    final success = await OrderService().placeOrder(newOrder);
    if (success) {
      _orders.insert(0, newOrder);
      notifyListeners();
    }
    return success;
  }

  Future<void> cancelOrder(String orderId) async {
    final success = await OrderService().updateOrderStatus(orderId, OrderStatus.cancelled);
    if (success) {
      final index = _orders.indexWhere((o) => o.orderId == orderId);
      if (index != -1) {
        _orders[index].status = OrderStatus.cancelled;
        notifyListeners();
      }
    }
  }
}
