import 'clothing_product.dart';

class CartItem {
  final ClothingProduct product;
  final String size;
  final String color;
  int quantity;

  CartItem({
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
  });

  String get cartId => '${product.id}_${size}_$color';

  double get totalPrice => product.currentPrice * quantity;
}
