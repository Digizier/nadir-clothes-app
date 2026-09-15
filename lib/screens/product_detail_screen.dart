import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants.dart';
import '../models/clothing_product.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ClothingProduct product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late String _selectedSize;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.availableSizes.first;
    _selectedColor = widget.product.availableColors.first;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'NADIR CLOTHES',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. High Resolution Hero Image
            Container(
              height: 380,
              width: double.infinity,
              color: AppColors.surface,
              child: CachedNetworkImage(
                imageUrl: widget.product.images.isNotEmpty
                    ? widget.product.images.first
                    : 'https://images.unsplash.com/photo-1597983073493-88cd35cf93b0?w=800',
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: AppColors.gold),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.image, color: AppColors.textMuted),
              ),
            ),

            // 2. Details Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fabric Badge
                  if (widget.product.fabric != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                      ),
                      child: Text(
                        widget.product.fabric!.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Title
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Price
                  Row(
                    children: [
                      Text(
                        'Rs. ${widget.product.currentPrice.toInt()}',
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (widget.product.hasDiscount)
                        Text(
                          'Rs. ${widget.product.price.toInt()}',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 3. Size Selector
                  const Text(
                    'SELECT SIZE',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: widget.product.availableSizes.map((sz) {
                      final isSelected = _selectedSize == sz;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSize = sz),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.gold : AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppColors.gold : AppColors.surfaceLight,
                            ),
                          ),
                          child: Text(
                            sz,
                            style: TextStyle(
                              color: isSelected ? AppColors.background : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // 4. Color Selector
                  const Text(
                    'SELECT COLOR',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: widget.product.availableColors.map((col) {
                      final isSelected = _selectedColor == col;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = col),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.surfaceLight : AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? AppColors.gold : AppColors.surfaceLight,
                            ),
                          ),
                          child: Text(
                            col,
                            style: TextStyle(
                              color: isSelected ? AppColors.gold : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // COD Info Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.surfaceLight),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.local_shipping_outlined, color: AppColors.gold, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cash on Delivery (COD)',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Pay cash when courier delivers parcel to your doorstep',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  if (widget.product.description != null) ...[
                    const Text(
                      'PRODUCT DETAILS',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],

                  const SizedBox(height: 100), // Bottom padding for sticky button
                ],
              ),
            ),
          ],
        ),
      ),

      // Sticky Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.surfaceLight)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleRadius(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    cart.addToCart(widget.product, _selectedSize, _selectedColor);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.surfaceLight,
                        content: Text(
                          'Added ${_selectedSize} ($_selectedColor) to bag!',
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                        action: SnackBarAction(
                          label: 'VIEW BAG',
                          textColor: AppColors.gold,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CartScreen()),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'ADD TO BAG',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
