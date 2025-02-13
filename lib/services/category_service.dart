import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';
import '../services/storage_service.dart';

/// FinanceArcade Category Service - Manages transaction categories with constant icons
class CategoryService extends ChangeNotifier {
  final _uuid = const Uuid();
  List<Category> _categories = [];

  List<Category> get categories => _categories;
  List<Category> get expenseCategories => _categories
      .where((c) =>
          c.type == CategoryTransactionType.expense ||
          c.type == CategoryTransactionType.both)
      .toList();
  List<Category> get incomeCategories => _categories
      .where((c) =>
          c.type == CategoryTransactionType.income ||
          c.type == CategoryTransactionType.both)
      .toList();

  CategoryService() {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final box = StorageService.categories;
    _categories = box.values.toList();
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    final box = StorageService.categories;
    await box.put(category.id, category);
    _categories.add(category);
    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    final box = StorageService.categories;
    await box.put(category.id, category);

    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async {
    final category = _categories.firstWhere((c) => c.id == id);
    if (category.isDefault) {
      throw Exception('Cannot delete default category');
    }

    final box = StorageService.categories;
    await box.delete(id);
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Future<Category> createCategory({
    required String name,
    required Color color,
    required IconData icon,
    required CategoryTransactionType type,
  }) async {
    final category = Category(
      id: _uuid.v4(),
      name: name,
      colorValue: color.value,
      iconCodePoint: icon.codePoint,
      type: type,
      isDefault: false,
    );

    await addCategory(category);
    return category;
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Category> getCategoriesByType(CategoryTransactionType type) {
    return _categories
        .where((c) => c.type == type || c.type == CategoryTransactionType.both)
        .toList();
  }

  // Predefined colors for category creation
  static const List<Color> categoryColors = [
    Color(0xFFFF6B6B), // Red
    Color(0xFF4ECDC4), // Teal
    Color(0xFF45B7D1), // Blue
    Color(0xFF96CEB4), // Green
    Color(0xFFFCEAA6), // Yellow
    Color(0xFFF38BA8), // Pink
    Color(0xFFDDA0DD), // Plum
    Color(0xFF98D8C8), // Mint
    Color(0xFFFFB347), // Orange
    Color(0xFFB19CD9), // Lavender
    Color(0xFF87CEEB), // Sky Blue
    Color(0xFFF0E68C), // Khaki
  ];

  // Predefined icons for category creation
  static const List<IconData> categoryIcons = [
    // Food & Dining
    Icons.restaurant,
    Icons.local_cafe,
    Icons.fastfood,

    // Transportation
    Icons.directions_car,
    Icons.local_gas_station,
    Icons.train,
    Icons.flight,
    Icons.directions_bus,
    Icons.motorcycle,

    // Shopping & Retail
    Icons.shopping_bag,
    Icons.shopping_cart,
    Icons.store,
    Icons.local_mall,

    // Entertainment
    Icons.movie,
    Icons.music_note,
    Icons.gamepad,
    Icons.sports_esports,
    Icons.camera_alt,

    // Home & Utilities
    Icons.home,
    Icons.apartment,
    Icons.receipt,
    Icons.power,
    Icons.water_drop,
    Icons.wifi,
    Icons.phone,

    // Health & Medical
    Icons.local_hospital,
    Icons.spa,
    Icons.fitness_center,
    Icons.pets,

    // Work & Business
    Icons.work,
    Icons.business,
    Icons.laptop,
    Icons.trending_up,
    Icons.account_balance,
    Icons.construction,

    // Education & Learning
    Icons.school,
    Icons.book,
    Icons.library_books,

    // Miscellaneous
    Icons.card_giftcard,
    Icons.celebration,
    Icons.subscriptions,
    Icons.brush,
    Icons.travel_explore,
  ];

  Future<void> resetToDefaults() async {
    final box = StorageService.categories;
    await box.clear();
    _categories.clear();

    // Reinitialize default categories manually
    await _initializeDefaultCategories();
    await _loadCategories();
  }

  Future<void> _initializeDefaultCategories() async {
    try {
      final categoriesBox = StorageService.categories;

      if (categoriesBox.isEmpty) {
        final defaultCategories = [
          // ✅ Fixed: Use constant icon code points from predefined icons
          Category(
            id: 'food_dining',
            name: 'Food & Dining',
            colorValue: 0xFFFF6B6B,
            iconCodePoint: Icons.restaurant.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.expense,
          ),
          Category(
            id: 'transportation',
            name: 'Transportation',
            colorValue: 0xFF4ECDC4,
            iconCodePoint: Icons.directions_car.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.expense,
          ),
          Category(
            id: 'bills_utilities',
            name: 'Bills & Utilities',
            colorValue: 0xFF45B7D1,
            iconCodePoint: Icons.receipt.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.expense,
          ),
          Category(
            id: 'shopping_retail',
            name: 'Shopping',
            colorValue: 0xFF96CEB4,
            iconCodePoint: Icons.shopping_bag.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.expense,
          ),
          Category(
            id: 'entertainment_fun',
            name: 'Entertainment',
            colorValue: 0xFFFCEAA6,
            iconCodePoint: Icons.movie.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.expense,
          ),
          Category(
            id: 'healthcare_medical',
            name: 'Healthcare',
            colorValue: 0xFFF38BA8,
            iconCodePoint: Icons.local_hospital.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.expense,
          ),
          Category(
            id: 'housing_rent',
            name: 'Housing & Rent',
            colorValue: 0xFFDDA0DD,
            iconCodePoint: Icons.home.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.expense,
          ),
          Category(
            id: 'education_learning',
            name: 'Education',
            colorValue: 0xFFB19CD9,
            iconCodePoint: Icons.school.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.expense,
          ),

          // Income Categories
          Category(
            id: 'salary_income',
            name: 'Salary',
            colorValue: 0xFF00C851,
            iconCodePoint: Icons.work.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.income,
          ),
          Category(
            id: 'business_profit',
            name: 'Business',
            colorValue: 0xFFFFB347,
            iconCodePoint: Icons.trending_up.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.income,
          ),
          Category(
            id: 'investment_returns',
            name: 'Investments',
            colorValue: 0xFF33B5E5,
            iconCodePoint: Icons.account_balance.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.income,
          ),
          Category(
            id: 'freelance_gigs',
            name: 'Freelance',
            colorValue: 0xFF87CEEB,
            iconCodePoint: Icons.laptop.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.income,
          ),
          Category(
            id: 'gifts_bonus',
            name: 'Gifts & Bonus',
            colorValue: 0xFFFFBB33,
            iconCodePoint: Icons.card_giftcard.codePoint, // ✅ Constant icon
            isDefault: true,
            type: CategoryTransactionType.income,
          ),
        ];

        for (final category in defaultCategories) {
          await categoriesBox.put(category.id, category);
        }

        debugPrint(
            'FinanceArcade: Initialized ${defaultCategories.length} default categories');
      }
    } catch (e) {
      debugPrint('FinanceArcade: Error initializing default categories: $e');
      throw Exception('Failed to initialize default categories: $e');
    }
  }
}
// Commit 31: 2025-02-10T20:50:12
// Commit 55: 2025-02-17T23:00:21
// Commit 94: 2025-03-01T11:10:50
// Commit 98: 2025-03-02T14:45:54
// Commit 136: 2025-03-13T20:26:05
// Commit 152: 2025-03-18T13:10:01
// Commit 4: 2025-02-02T21:52:12
// Commit 17: 2025-02-06T17:58:50
// Commit 29: 2025-02-10T06:22:56
// Commit 30: 2025-02-10T14:16:14
// Commit 31: 2025-02-10T21:17:27
// Commit 39: 2025-02-13T05:42:56
// Commit 40: 2025-02-13T12:54:02
// Commit 51: 2025-02-16T18:28:28
// Commit 52: 2025-02-17T01:28:02
// Commit 63: 2025-02-20T07:21:05
// Commit 64: 2025-02-20T14:50:57
// Commit 67: 2025-02-21T12:07:26
// Commit 86: 2025-02-27T02:30:19
// Commit 89: 2025-02-27T23:12:28
// Commit 100: 2025-03-03T05:23:38
// Commit 117: 2025-03-08T05:43:03
// Commit 158: 2025-03-20T08:15:43
// Commit 177: 2025-03-25T22:49:11
// Commit 190: 2025-03-29T18:08:19
// Commit 15: 2025-02-06T03:19:23
// Commit 25: 2025-02-09T02:55:07
// Commit 27: 2025-02-09T16:29:34
// Commit 35: 2025-02-12T00:55:02
// Commit 52: 2025-02-17T01:42:41
// Commit 60: 2025-02-19T10:06:23
// Commit 76: 2025-02-24T03:43:04
// Commit 80: 2025-02-25T07:36:49
// Commit 83: 2025-02-26T05:05:17
// Commit 93: 2025-03-01T03:23:04
// Commit 111: 2025-03-06T11:17:14
// Commit 113: 2025-03-07T00:59:03
// Commit 114: 2025-03-07T08:22:41
// Commit 125: 2025-03-10T14:41:13
// Commit 147: 2025-03-17T02:04:35
// Commit 156: 2025-03-19T18:21:03
// Commit 162: 2025-03-21T12:41:32
// Commit 174: 2025-03-25T01:32:23
// Commit 175: 2025-03-25T08:39:08
// Commit 177: 2025-03-25T22:12:51
// Commit 178: 2025-03-26T05:43:07
// Commit 180: 2025-03-26T20:11:38
// Commit 1: 2025-02-02T00:35:43
// Commit 6: 2025-02-03T11:59:30
// Commit 13: 2025-02-05T13:45:29
// Commit 29: 2025-02-10T06:33:55
// Commit 35: 2025-02-12T01:42:45
// Commit 41: 2025-02-13T19:46:23
// Commit 55: 2025-02-17T23:11:55
// Commit 58: 2025-02-18T19:57:14
// Commit 60: 2025-02-19T10:10:42
// Commit 69: 2025-02-22T01:54:44
// Commit 79: 2025-02-25T00:45:06
// Commit 83: 2025-02-26T05:15:35
// Commit 130: 2025-03-12T01:59:16
// Commit 132: 2025-03-12T15:32:45
// Commit 142: 2025-03-15T14:19:49
// Commit 144: 2025-03-16T04:33:46
// Commit 161: 2025-03-21T05:08:30
// Commit 178: 2025-03-26T05:18:11
// Commit 183: 2025-03-27T17:22:53
// Commit 199: 2025-04-01T10:24:52
// Commit 4: 2025-02-02T22:02:43
// Commit 10: 2025-02-04T16:09:06
// Commit 12: 2025-02-05T06:12:37
// Commit 15: 2025-02-06T03:59:27
// Commit 28: 2025-02-09T23:52:56
// Commit 34: 2025-02-11T18:23:40
// Commit 48: 2025-02-15T21:26:43
// Commit 60: 2025-02-19T10:34:22
// Commit 61: 2025-02-19T17:35:15
// Commit 72: 2025-02-22T23:08:29
// Commit 75: 2025-02-23T20:45:05
// Commit 78: 2025-02-24T17:16:35
// Commit 87: 2025-02-27T09:22:18
// Commit 100: 2025-03-03T05:54:44
// Commit 120: 2025-03-09T03:06:47
// Commit 133: 2025-03-12T23:26:40
// Commit 140: 2025-03-15T00:27:29
// Commit 145: 2025-03-16T12:01:07
// Commit 159: 2025-03-20T15:05:27
// Commit 173: 2025-03-24T18:43:00
// Commit 175: 2025-03-25T08:46:49
// Commit 191: 2025-03-30T01:34:25
// Commit 194: 2025-03-30T22:51:31
// Commit 195: 2025-03-31T05:34:15
// Commit 196: 2025-03-31T12:47:27
// Commit 1: 2025-02-02T00:44:16
// Commit 7: 2025-02-03T19:08:13
// Commit 13: 2025-02-05T13:50:13
// Commit 19: 2025-02-07T07:58:41
// Commit 41: 2025-02-13T19:39:27
