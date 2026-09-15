import 'package:flutter/foundation.dart';
import '../models/clothing_product.dart';
import '../models/cart_item.dart';
import '../core/constants.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get itemCount => _items.values.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => _items.values.fold(0.0, (sum, i) => sum + i.totalPrice);

  double get deliveryFee {
    if (subtotal == 0) return 0.0;
    if (subtotal >= AppConstants.freeDeliveryThreshold) return 0.0;
    return AppConstants.standardDeliveryFee;
  }

  double get totalAmount => subtotal + deliveryFee;

  bool get qualifiesForFreeDelivery => subtotal >= AppConstants.freeDeliveryThreshold;

  double get amountNeededForFreeDelivery =>
      (AppConstants.freeDeliveryThreshold - subtotal).clamp(0.0, AppConstants.freeDeliveryThreshold);

  void addToCart(ClothingProduct product, String size, String color) {
    final key = '${product.id}_${size}_$color';
    if (_items.containsKey(key)) {
      _items[key]!.quantity++;
    } else {
      _items[key] = CartItem(
        product: product,
        size: size,
        color: color,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  void increment(String cartId) {
    if (_items.containsKey(cartId)) {
      _items[cartId]!.quantity++;
      notifyListeners();
    }
  }

  void decrement(String cartId) {
    if (_items.containsKey(cartId)) {
      if (_items[cartId]!.quantity > 1) {
        _items[cartId]!.quantity--;
      } else {
        _items.remove(cartId);
      }
      notifyListeners();
    }
  }

  void removeItem(String cartId) {
    _items.remove(cartId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
