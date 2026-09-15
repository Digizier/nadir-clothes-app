class ProductVariant {
  final String id;
  final String productId;
  final String size;
  final String color;
  final String? colorHex;
  final int stockQuantity;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.size,
    required this.color,
    this.colorHex,
    required this.stockQuantity,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      size: map['size'] ?? 'Standard',
      color: map['color'] ?? 'Default',
      colorHex: map['color_hex'] ?? '#000000',
      stockQuantity: map['stock_quantity'] ?? 0,
    );
  }
}

class ClothingProduct {
  final String id;
  final String title;
  final String slug;
  final String? description;
  final double price;
  final double? discountPrice;
  final String? categoryId;
  final String? fabric;
  final List<String> images;
  final bool isFeatured;
  final List<ProductVariant> variants;

  ClothingProduct({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    required this.price,
    this.discountPrice,
    this.categoryId,
    this.fabric,
    required this.images,
    required this.isFeatured,
    this.variants = const [],
  });

  double get currentPrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  List<String> get availableSizes {
    final s = variants.map((v) => v.size).toSet().toList();
    if (s.isEmpty) return ['Small', 'Medium', 'Large', 'XL'];
    return s;
  }

  List<String> get availableColors {
    final c = variants.map((v) => v.color).toSet().toList();
    if (c.isEmpty) return ['Standard'];
    return c;
  }

  factory ClothingProduct.fromMap(Map<String, dynamic> map) {
    List<String> imgs = [];
    if (map['images'] != null) {
      if (map['images'] is List) {
        imgs = List<String>.from(map['images']);
      }
    }

    List<ProductVariant> vars = [];
    if (map['product_variants'] != null && map['product_variants'] is List) {
      vars = (map['product_variants'] as List)
          .map((v) => ProductVariant.fromMap(v))
          .toList();
    }

    return ClothingProduct(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      slug: map['slug'] ?? '',
      description: map['description'],
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (map['discount_price'] as num?)?.toDouble(),
      categoryId: map['category_id'],
      fabric: map['fabric'],
      images: imgs,
      isFeatured: map['is_featured'] ?? false,
      variants: vars,
    );
  }
}
