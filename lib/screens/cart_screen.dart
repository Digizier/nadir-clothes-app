import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'SHOPPING BAG',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 70, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Shopping Bag is Empty',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore our latest clothing catalog to add items',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleRadius(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('START SHOPPING', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Free Delivery Progress Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: AppColors.surfaceLight,
                  child: Row(
                    children: [
                      Icon(
                        cart.qualifiesForFreeDelivery ? Icons.check_circle : Icons.local_shipping,
                        color: cart.qualifiesForFreeDelivery ? AppColors.success : AppColors.gold,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          cart.qualifiesForFreeDelivery
                              ? 'Congratulations! You qualify for FREE Delivery.'
                              : 'Add Rs. ${cart.amountNeededForFreeDelivery.toInt()} more for FREE Delivery!',
                          style: TextStyle(
                            color: cart.qualifiesForFreeDelivery ? AppColors.success : AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Items List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.surfaceLight),
                        ),
                        child: Row(
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item.product.images.isNotEmpty
                                    ? item.product.images.first
                                    : 'https://images.unsplash.com/photo-1597983073493-88cd35cf93b0?w=800',
                                width: 70,
                                height: 85,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Item Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceLight,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Size: ${item.size}',
                                          style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        item.color,
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Rs. ${item.totalPrice.toInt()}',
                                    style: const TextStyle(
                                      color: AppColors.gold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Quantity Controller
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.textSecondary, size: 22),
                                  onPressed: () => cart.decrement(item.cartId),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: AppColors.textSecondary, size: 22),
                                  onPressed: () => cart.increment(item.cartId),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Checkout Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.surfaceLight)),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.between,
                          children: [
                            const Text('Subtotal:', style: TextStyle(color: AppColors.textSecondary)),
                            Text('Rs. ${cart.subtotal.toInt()}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.between,
                          children: [
                            const Text('Delivery Charges:', style: TextStyle(color: AppColors.textSecondary)),
                            Text(
                              cart.deliveryFee == 0 ? 'FREE' : 'Rs. ${cart.deliveryFee.toInt()}',
                              style: TextStyle(
                                color: cart.deliveryFee == 0 ? AppColors.success : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: AppColors.surfaceLight, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.between,
                          children: [
                            const Text(
                              'Total Amount (COD):',
                              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'Rs. ${cart.totalAmount.toInt()}',
                              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: AppColors.background,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleRadius(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                              );
                            },
                            child: const Text(
                              'PROCEED TO COD CHECKOUT',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
