// lib/models/order_model.dart

import 'cart_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled,
}

class OrderModel {
  final String orderId;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String? buyerId;
  OrderStatus status;

  OrderModel({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.buyerId,
    this.status = OrderStatus.pending,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.confirmed: return 'Confirmed';
      case OrderStatus.shipped: return 'Shipped';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json, List<CartItem> items) {
    return OrderModel(
      orderId: json['id'] as String,
      items: items,
      totalAmount: (json['total_amount'] as num).toDouble(),
      orderDate: DateTime.parse(json['order_date'] as String),
      buyerId: json['buyer_id'] as String?,
      status: _statusFromString(json['status'] as String),
    );
  }

  static OrderStatus _statusFromString(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => OrderStatus.pending,
    );
  }
}
