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
