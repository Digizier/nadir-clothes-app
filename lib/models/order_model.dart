class OrderItemModel {
  final String productTitle;
  final String size;
  final String color;
  final double unitPrice;
  final int quantity;
  final double totalPrice;

  OrderItemModel({
    required this.productTitle,
    required this.size,
    required this.color,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productTitle: map['product_title'] ?? '',
      size: map['size'] ?? '',
      color: map['color'] ?? '',
      unitPrice: (map['unit_price'] as num?)?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 1,
      totalPrice: (map['total_price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final String shippingAddress;
  final String city;
  final double totalAmount;
  final double deliveryCharges;
  final String orderStatus;
  final String paymentMethod;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.shippingAddress,
    required this.city,
    required this.totalAmount,
    required this.deliveryCharges,
    required this.orderStatus,
    required this.paymentMethod,
    required this.createdAt,
    this.items = const [],
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    List<OrderItemModel> itemsList = [];
    if (map['order_items'] != null && map['order_items'] is List) {
      itemsList = (map['order_items'] as List)
          .map((i) => OrderItemModel.fromMap(i))
          .toList();
    }

    return OrderModel(
      id: map['id'] ?? '',
      orderNumber: map['order_number'] ?? '',
      customerName: map['customer_name'] ?? '',
      customerPhone: map['customer_phone'] ?? '',
      shippingAddress: map['shipping_address'] ?? '',
      city: map['city'] ?? '',
      totalAmount: (map['total_amount'] as num?)?.toDouble() ?? 0.0,
      deliveryCharges: (map['delivery_charges'] as num?)?.toDouble() ?? 200.0,
      orderStatus: map['order_status'] ?? 'pending',
      paymentMethod: map['payment_method'] ?? 'COD',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      items: itemsList,
    );
  }
}
