import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/cart_provider.dart';
import '../services/supabase_service.dart';
import 'order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController(text: 'Lahore');
  final _notesController = TextEditingController();

  final SupabaseService _service = SupabaseService();
  bool _isSubmitting = false;

  final List<String> _popularCities = [
    'Lahore', 'Karachi', 'Islamabad', 'Rawalpindi', 'Faisalabad', 
    'Multan', 'Peshawar', 'Gujranwala', 'Sialkot', 'Quetta', 'Other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handlePlaceOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = Provider.of<CartProvider>(context, listen: false);
    if (cart.items.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      final order = await _service.placeCodOrder(
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        shippingAddress: _addressController.text.trim(),
        city: _cityController.text.trim(),
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        cartItems: cart.items,
        deliveryFee: cart.deliveryFee,
        totalAmount: cart.totalAmount,
      );

      // Clear cart
      cart.clearCart();

      // Navigate to tracking
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OrderTrackingScreen(initialOrder: order)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: AppColors.error, content: Text('Order failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'CHECKOUT',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Details Header
              const Text(
                'DELIVERY ADDRESS',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 14),

              // Full Name
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration('Full Name *', 'e.g. Muhammad Ali'),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 14),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration('Mobile Number (For Courier Contact) *', 'e.g. 0300 1234567'),
                validator: (val) => (val == null || val.trim().length < 10) ? 'Please enter a valid phone number' : null,
              ),
              const SizedBox(height: 14),

              // City
              DropdownButtonFormField<String>(
                value: _popularCities.contains(_cityController.text) ? _cityController.text : _popularCities.first,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration('City *', ''),
                items: _popularCities.map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _cityController.text = val);
                },
              ),
              const SizedBox(height: 14),

              // Complete Address
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration('Complete Street Address / House # *', 'House, Street, Block, Area'),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter complete address' : null,
              ),
              const SizedBox(height: 14),

              // Special Notes
              TextFormField(
                controller: _notesController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration('Delivery Notes (Optional)', 'e.g. Call before arriving'),
              ),

              const SizedBox(height: 28),

              // Payment Method (COD ONLY)
              const Text(
                'PAYMENT METHOD',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.gold, size: 24),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Cash on Delivery (COD)',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Pay with cash to courier rider upon receiving parcel',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Order Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.surfaceLight),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        const Text('Items Total:', style: TextStyle(color: AppColors.textSecondary)),
                        Text('Rs. ${cart.subtotal.toInt()}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        const Text('Shipping Fee:', style: TextStyle(color: AppColors.textSecondary)),
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
                          'Total Payable (COD):',
                          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Rs. ${cart.totalAmount.toInt()}',
                          style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleRadius(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isSubmitting ? null : _handlePlaceOrder,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                        )
                      : const Text(
                          'CONFIRM CASH ON DELIVERY ORDER',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
      filled: true,
      fillColor: AppColors.surface,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.surfaceLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.gold),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}
