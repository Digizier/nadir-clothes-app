import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/order_model.dart';
import '../services/supabase_service.dart';
import 'home_screen.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel initialOrder;

  const OrderTrackingScreen({Key? key, required this.initialOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = SupabaseService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home_outlined, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'ORDER TRACKING',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: StreamBuilder<OrderModel?>(
        stream: service.streamOrder(initialOrder.id),
        initialData: initialOrder,
        builder: (context, snapshot) {
          final order = snapshot.data ?? initialOrder;
          final status = order.orderStatus.toLowerCase();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Success Badge Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.gold.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: AppColors.background, size: 30),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Thank You for Your Order!',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Order ID: ${order.orderNumber}',
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Live Real-time tracking enabled. Courier will collect cash on delivery.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Live Status Timeline
                const Text(
                  'DELIVERY PROGRESS',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceLight),
                  ),
                  child: Column(
                    children: [
                      _buildTimelineStep(
                        title: 'Order Placed',
                        subtitle: 'Your COD order has been received.',
                        isDone: true,
                        isActive: status == 'pending',
                        isLast: false,
                      ),
                      _buildTimelineStep(
                        title: 'Order Confirmed',
                        subtitle: 'Fabric inspected and packed by Nadir Clothes.',
                        isDone: status == 'confirmed' || status == 'shipped' || status == 'delivered',
                        isActive: status == 'confirmed',
                        isLast: false,
                      ),
                      _buildTimelineStep(
                        title: 'Dispatched / In Transit',
                        subtitle: 'Parcel handed over to courier service.',
                        isDone: status == 'shipped' || status == 'delivered',
                        isActive: status == 'shipped',
                        isLast: false,
                      ),
                      _buildTimelineStep(
                        title: 'Delivered',
                        subtitle: 'Cash paid to rider and parcel received.',
                        isDone: status == 'delivered',
                        isActive: status == 'delivered',
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Order Details Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Shipping Details',
                        style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Text('Recipient: ${order.customerName}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text('Phone: ${order.customerPhone}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text('Address: ${order.shippingAddress}, ${order.city}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      const Divider(color: AppColors.surfaceLight, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          const Text('Total Amount Payable (COD):', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          Text('Rs. ${order.totalAmount.toInt()}', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Back to Store Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceLight,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleRadius(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text('CONTINUE SHOPPING', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isActive,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDone ? AppColors.gold : AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? AppColors.goldLight : Colors.transparent,
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: AppColors.background)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isDone ? AppColors.gold : AppColors.surfaceLight,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDone || isActive ? AppColors.textPrimary : AppColors.textMuted,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
