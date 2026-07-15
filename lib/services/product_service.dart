import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import 'supabase_service.dart';

class ProductService {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<Product>> fetchAllProducts() async {
    try {
      final data = await _client
          .from('products')
          .select()
          .order('created_at', ascending: false);
      
      return (data as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Product>> fetchFarmerProducts(String farmerId) async {
    try {
      final data = await _client
          .from('products')
          .select()
          .eq('farmer_id', farmerId)
          .order('created_at', ascending: false);
      
      return (data as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      await _client.from('products').insert(product.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _client.from('products').delete().eq('id', productId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
