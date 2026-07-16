import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'supabase_service.dart';

class OrderService {
  final SupabaseClient _client = SupabaseService.client;

  Future<bool> placeOrder(OrderModel order) async {
    try {
      // 1. Insert into orders table
      await _client.from('orders').insert({
        'id': order.orderId,
        'buyer_id': order.buyerId,
        'total_amount': order.totalAmount,
        'status': order.status.name,
      });

      // 2. Insert into order_items table
      final itemsToInsert = order.items
          .map((item) => {
                'order_id': order.orderId,
                'product_id': item.product.id,
                'quantity': item.quantity,
                'price_at_purchase': item.product.pricePerUnit,
              })
          .toList();

      await _client.from('order_items').insert(itemsToInsert);

      return true;
    } catch (e, st) {
      // Log the error so we can see the root cause in logs
      print('OrderService.placeOrder error: $e');
      print(st);
      return false;
    }
  }

  Future<List<OrderModel>> fetchBuyerOrders(String buyerId) async {
    try {
      final response = await _client
          .from('orders')
          .select('*, order_items(*, products(*))')
          .eq('buyer_id', buyerId)
          .order('order_date', ascending: false);

      final List data = response as List;

      return data.map((orderJson) {
        final List itemsJson = orderJson['order_items'] as List;
        final items = itemsJson.map((item) {
          final product = Product.fromJson(item['products']);
          return CartItem(
            id: item['id'].toString(),
            product: product,
            quantity: item['quantity'] as int,
          );
        }).toList();

        return OrderModel.fromJson(orderJson, items);
      }).toList();
    } catch (e, st) {
      print('OrderService.fetchBuyerOrders error: $e');
      print(st);
      return [];
    }
  }

  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _client
          .from('orders')
          .update({'status': status.name}).eq('id', orderId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
