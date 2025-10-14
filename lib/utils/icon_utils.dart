import 'package:flutter/material.dart';

/// FinanceArcade Icon Utilities - Tree-shake friendly icon management
class IconUtils {
  /// Map of icon names to their constant IconData for safe usage
  static const Map<String, IconData> iconMap = {
    // Food & Dining
    'restaurant': Icons.restaurant,
    'local_cafe': Icons.local_cafe,
    'fastfood': Icons.fastfood,

    // Transportation
    'directions_car': Icons.directions_car,
    'local_gas_station': Icons.local_gas_station,
    'train': Icons.train,
    'flight': Icons.flight,
    'directions_bus': Icons.directions_bus,

    // Shopping
    'shopping_bag': Icons.shopping_bag,
    'shopping_cart': Icons.shopping_cart,
    'store': Icons.store,

    // Entertainment
    'movie': Icons.movie,
    'music_note': Icons.music_note,
    'gamepad': Icons.gamepad,

    // Utilities
    'receipt': Icons.receipt,
    'power': Icons.power,
    'water_drop': Icons.water_drop,
    'wifi': Icons.wifi,
    'phone': Icons.phone,

    // Health
    'local_hospital': Icons.local_hospital,
    'spa': Icons.spa,
    'fitness_center': Icons.fitness_center,

    // Work
    'work': Icons.work,
    'business': Icons.business,
    'laptop': Icons.laptop,
    'trending_up': Icons.trending_up,
    'account_balance': Icons.account_balance,

    // Home
    'home': Icons.home,
    'apartment': Icons.apartment,

    // Education
    'school': Icons.school,
    'book': Icons.book,

    // Gifts
    'card_giftcard': Icons.card_giftcard,
    'celebration': Icons.celebration,
  };

  /// Get IconData by code point safely
  static IconData getIconByCodePoint(int codePoint) {
    // Find matching icon in our predefined set
    for (final icon in iconMap.values) {
      if (icon.codePoint == codePoint) {
        return icon;
      }
    }

    // Return safe fallback
    return Icons.category;
  }

  /// Get IconData by name safely
  static IconData getIconByName(String name) {
    return iconMap[name] ?? Icons.category;
  }

  /// Get all available icons as a list
  static List<IconData> get allIcons => iconMap.values.toList();

  /// Get icon code point safely
  static int getCodePoint(IconData icon) {
    return icon.codePoint;
  }
}

