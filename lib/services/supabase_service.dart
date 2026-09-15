import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/clothing_product.dart';
import '../models/cart_item.dart';
import '../models/order_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // 1. Fetch Categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .order('name');
    return List<Map<String, dynamic>>.from(response);
  }

  // 2. Fetch Products with Variants
  Future<List<ClothingProduct>> getProducts({String? categoryId}) async {
    var query = _client.from('products').select('''
      *,
      product_variants (*)
    ''').eq('is_active', true);

    if (categoryId != null && categoryId.isNotEmpty) {
      query = query.eq('category_id', categoryId);
    }

    final response = await query.order('created_at', ascending: false);
    return (response as List).map((p) => ClothingProduct.fromMap(p)).toList();
  }

  // 3. Place Cash on Delivery (COD) Order
  Future<OrderModel> placeCodOrder({
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    required String shippingAddress,
    required String city,
    String? notes,
    required List<CartItem> cartItems,
    required double deliveryFee,
    required double totalAmount,
  }) async {
    // Generate Order Number: NC-XXXXXX
    final orderNum = 'NC-${(100000 + DateTime.now().millisecondsSinceEpoch % 900000)}';

    // A. Insert Order
    final orderRes = await _client.from('orders').insert({
      'order_number': orderNum,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_email': customerEmail,
      'shipping_address': shippingAddress,
      'city': city,
      'total_amount': totalAmount,
      'delivery_charges': deliveryFee,
      'payment_method': 'COD',
      'order_status': 'pending',
      'notes': notes,
    }).select().single();

    final orderId = orderRes['id'];

    // B. Insert Order Items
    final itemsPayload = cartItems.map((item) => {
      'order_id': orderId,
      'product_id': item.product.id,
      'product_title': item.product.title,
      'size': item.size,
      'color': item.color,
      'unit_price': item.product.currentPrice,
      'quantity': item.quantity,
      'total_price': item.totalPrice,
    }).toList();

    await _client.from('order_items').insert(itemsPayload);

    return OrderModel.fromMap(orderRes);
  }

  // 4. Real-time Stream for Order Tracking
  Stream<OrderModel?> streamOrder(String orderId) {
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('id', orderId)
        .map((data) => data.isNotEmpty ? OrderModel.fromMap(data.first) : null);
  }
}
