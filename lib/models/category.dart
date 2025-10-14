import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 4)
enum CategoryTransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
  @HiveField(2)
  both,
}

@HiveType(typeId: 3)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int colorValue;

  @HiveField(3)
  final int iconCodePoint;

  @HiveField(4)
  final bool isDefault;

  @HiveField(5)
  final CategoryTransactionType type;

  Category({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.iconCodePoint,
    required this.type,
    this.isDefault = false,
  });

  // Getter for Color object
  Color get color => Color(colorValue);

  // ✅ Fixed: Use static method to create IconData with proper tree-shaking
  IconData get icon => _getIconDataFromCodePoint(iconCodePoint);

  // Helper method to safely create IconData
  static IconData _getIconDataFromCodePoint(int codePoint) {
    // Map common icon code points to their constant IconData equivalents
    switch (codePoint) {
      // Food & Dining
      case 0xe57a:
        return Icons.restaurant;
      case 0xe541:
        return Icons.local_cafe;

      // Transportation
      case 0xe530:
        return Icons.directions_car;
      case 0xe571:
        return Icons.local_gas_station;
      case 0xe532:
        return Icons.train;
      case 0xe539:
        return Icons.flight;

      // Shopping
      case 0xe8cc:
        return Icons.shopping_bag;
      case 0xe8d1:
        return Icons.shopping_cart;
      case 0xe8b6:
        return Icons.receipt;

      // Entertainment
      case 0xe419:
        return Icons.movie;
      case 0xe405:
        return Icons.music_note;
      case 0xe30e:
        return Icons.gamepad;

      // Utilities & Bills
      case 0xe63c:
        return Icons.power;
      case 0xe798:
        return Icons.water_drop;
      case 0xe63e:
        return Icons.wifi;
      case 0xe0cd:
        return Icons.phone;

      // Health & Medical
      case 0xe588:
        return Icons.local_hospital;
      case 0xe518:
        return Icons.spa;

      // Work & Income
      case 0xe8ac:
        return Icons.work;
      case 0xe1af:
        return Icons.business;
      case 0xe30d:
        return Icons.laptop;
      case 0xe8d0:
        return Icons.trending_up;
      case 0xe84f:
        return Icons.account_balance;

      // Home & Housing
      case 0xe88a:
        return Icons.home;
      case 0xe80b:
        return Icons.apartment;

      // Education
      case 0xe80c:
        return Icons.school;
      case 0xe8f7:
        return Icons.book;

      // Fitness & Health
      case 0xe540:
        return Icons.fitness_center;
      case 0xe91d:
        return Icons.sports_esports;

      // Default fallback icons
      default:
        // Return a safe default icon for unknown code points
        if (codePoint >= 0xe000 && codePoint <= 0xf8ff) {
          // Valid Material Icons range - create IconData safely
          return const IconData(0xe88a,
              fontFamily: 'MaterialIcons'); // home icon as fallback
        }
        return Icons.category; // Safe fallback
    }
  }

  // Create a copy with updated fields
  Category copyWith({
    String? id,
    String? name,
    int? colorValue,
    int? iconCodePoint,
    CategoryTransactionType? type,
    bool? isDefault,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  // Convert to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorValue': colorValue,
      'iconCodePoint': iconCodePoint,
      'type': type.index,
      'isDefault': isDefault,
    };
  }

  // Create from Map for JSON deserialization
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      colorValue: map['colorValue'] as int,
      iconCodePoint: map['iconCodePoint'] as int,
      type: CategoryTransactionType.values[map['type'] as int],
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FinanceArcade Category(id: $id, name: $name, type: $type)';
  }
}

/// FinanceArcade - Predefined category icon mappings for tree-shaking optimization
class CategoryIcons {
  // Expense Category Icons
  static const IconData foodDining = Icons.restaurant;
  static const IconData transportation = Icons.directions_car;
  static const IconData shopping = Icons.shopping_bag;
  static const IconData entertainment = Icons.movie;
  static const IconData utilities = Icons.receipt;
  static const IconData healthcare = Icons.local_hospital;
  static const IconData housing = Icons.home;
  static const IconData education = Icons.school;

  // Income Category Icons
  static const IconData salary = Icons.work;
  static const IconData business = Icons.trending_up;
  static const IconData investment = Icons.account_balance;
  static const IconData freelance = Icons.laptop;
  static const IconData gifts = Icons.card_giftcard;

  // Common utility icons
  static const IconData gasStation = Icons.local_gas_station;
  static const IconData coffee = Icons.local_cafe;
  static const IconData fitness = Icons.fitness_center;
  static const IconData phone = Icons.phone;
  static const IconData wifi = Icons.wifi;
  static const IconData power = Icons.power;

  // Get all available icons as a list for category selection
  static const List<IconData> allIcons = [
    // Food & Dining
    foodDining,
    coffee,
    Icons.fastfood,

    // Transportation
    transportation,
    gasStation,
    Icons.train,
    Icons.flight,
    Icons.directions_bus,

    // Shopping & Retail
    shopping,
    Icons.shopping_cart,
    Icons.store,

    // Entertainment
    entertainment,
    Icons.music_note,
    Icons.gamepad,
    Icons.sports_esports,

    // Utilities & Bills
    utilities,
    phone,
    wifi,
    power,
    Icons.water_drop,

    // Health & Medical
    healthcare,
    Icons.spa,
    fitness,
    Icons.pets,

    // Work & Income
    salary,
    business,
    investment,
    freelance,

    // Home & Housing
    housing,
    Icons.apartment,
    Icons.construction,

    // Education & Learning
    education,
    Icons.book,
    Icons.library_books,

    // Gifts & Miscellaneous
    gifts,
    Icons.celebration,
    Icons.card_membership,
  ];

  // Get icon by name for backward compatibility
  static IconData getIconByName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'restaurant':
      case 'food':
        return foodDining;
      case 'car':
      case 'transport':
        return transportation;
      case 'shopping':
        return shopping;
      case 'movie':
      case 'entertainment':
        return entertainment;
      case 'receipt':
      case 'bills':
        return utilities;
      case 'hospital':
      case 'health':
        return healthcare;
      case 'home':
      case 'housing':
        return housing;
      case 'work':
      case 'salary':
        return salary;
      default:
        return Icons.category;
    }
  }
}

