import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Nadir Clothes';
  static const String tagline = 'Premium Apparel • Est. 2026';

  // Supabase Credentials
  static const String supabaseUrl = 'https://yowcldgfwsmewakgegyl.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlvd2NsZGdmd3NtZXdha2dlZ3lsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk0NzQzNDEsImV4cCI6MjEwNTA1MDM0MX0.nHwKvz783yjsfY2vDT8q2fXMcy4tInCZsUL4I-h6Av4';

  // Store Rules
  static const double standardDeliveryFee = 200.0;
  static const double freeDeliveryThreshold = 3000.0;
  static const String supportPhone = '+92 300 1234567';
}

class AppColors {
  static const Color background = Color(0xFF070B14);
  static const Color surface = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFF1E293B);
  
  // Luxury Gold Accents
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3E5AB);
  static const Color goldDark = Color(0xFFAA771C);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
}
