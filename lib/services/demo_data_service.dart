import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../services/transaction_service.dart';
import '../services/budget_service.dart';
import '../services/category_service.dart';
import '../services/storage_service.dart';

class DemoDataService {
  static const String _demoDataKey = 'demo_data_loaded';

  static Future<void> loadDemoData({
    required TransactionService transactionService,
    required BudgetService budgetService,
    required CategoryService categoryService,
  }) async {
    try {
      // Check if demo data already loaded
      final settings = StorageService.settings;
      final isLoaded = settings.get(_demoDataKey, defaultValue: false) as bool;

      if (isLoaded) {
        debugPrint('Demo data already loaded');
        return;
      }

      debugPrint('Loading FinanceArcade demo data...');

      // Clear existing data first
      await _clearExistingData(transactionService, budgetService);

      // Load demo transactions
      await _loadDemoTransactions(transactionService, categoryService);

      // Load demo budgets
      await _loadDemoBudgets(budgetService, categoryService);

      // Mark demo data as loaded
      await settings.put(_demoDataKey, true);

      debugPrint('FinanceArcade demo data loaded successfully!');
    } catch (e) {
      debugPrint('Error loading demo data: $e');
      rethrow;
    }
  }

  static Future<void> clearDemoData({
    required TransactionService transactionService,
    required BudgetService budgetService,
  }) async {
    try {
      await _clearExistingData(transactionService, budgetService);

      final settings = StorageService.settings;
      await settings.put(_demoDataKey, false);

      debugPrint('Demo data cleared successfully!');
    } catch (e) {
      debugPrint('Error clearing demo data: $e');
      rethrow;
    }
  }

  static bool get isDemoDataLoaded {
    final settings = StorageService.settings;
    return settings.get(_demoDataKey, defaultValue: false) as bool;
  }

  static Future<void> _clearExistingData(
    TransactionService transactionService,
    BudgetService budgetService,
  ) async {
    await transactionService.clearAllTransactions();
    await budgetService.clearAllBudgets();
  }

  static Future<void> _loadDemoTransactions(
    TransactionService transactionService,
    CategoryService categoryService,
  ) async {
    final now = DateTime.now();
    final random = Random();

    // Get available categories
    final expenseCategories = categoryService.expenseCategories;
    final incomeCategories = categoryService.incomeCategories;

    if (expenseCategories.isEmpty || incomeCategories.isEmpty) {
      debugPrint('Categories not available for demo data');
      return;
    }

    final demoTransactions = <Transaction>[];
    int transactionId = 1;

    // Generate income transactions (salary, freelance, etc.)
    for (int i = 0; i < 8; i++) {
      final incomeDate = now.subtract(Duration(days: random.nextInt(90)));
      final incomeCategory =
          incomeCategories[random.nextInt(incomeCategories.length)];

      double amount;
      String title;
      String? description;

      switch (incomeCategory.id) {
        case 'salary':
          amount = 3500 + random.nextDouble() * 1500; // $3500-5000
          title = 'Monthly Salary';
          description = 'Software Developer Salary';
          break;
        case 'freelance':
          amount = 800 + random.nextDouble() * 1200; // $800-2000
          title = 'Freelance Project';
          description = 'Web development project completion';
          break;
        case 'investment':
          amount = 200 + random.nextDouble() * 800; // $200-1000
          title = 'Investment Returns';
          description = 'Stock dividends and returns';
          break;
        default:
          amount = 500 + random.nextDouble() * 1000;
          title = 'Income';
          description = null;
      }

      demoTransactions.add(Transaction(
        id: 'demo_income_$transactionId',
        title: title,
        amount: double.parse(amount.toStringAsFixed(2)),
        description: description,
        categoryId: incomeCategory.id,
        date: incomeDate,
        type: TransactionType.income,
      ));
      transactionId++;
    }

    // Generate expense transactions with realistic patterns
    final expenseData = [
      // Food & Dining
      {
        'category': 'food',
        'titles': [
          'Grocery Shopping',
          'Restaurant Dinner',
          'Coffee Shop',
          'Fast Food',
          'Lunch Meeting'
        ],
        'amounts': [50, 150],
        'frequency': 25
      },

      // Transportation
      {
        'category': 'transport',
        'titles': [
          'Gas Station',
          'Uber Ride',
          'Public Transport',
          'Car Maintenance',
          'Parking Fee'
        ],
        'amounts': [20, 80],
        'frequency': 15
      },

      // Bills & Utilities
      {
        'category': 'bills',
        'titles': [
          'Electricity Bill',
          'Internet Bill',
          'Phone Bill',
          'Water Bill',
          'Insurance'
        ],
        'amounts': [50, 200],
        'frequency': 8
      },

      // Shopping
      {
        'category': 'shopping',
        'titles': [
          'Online Shopping',
          'Clothing Store',
          'Electronics',
          'Home Decor',
          'Books'
        ],
        'amounts': [30, 300],
        'frequency': 20
      },

      // Entertainment
      {
        'category': 'entertainment',
        'titles': [
          'Movie Tickets',
          'Streaming Service',
          'Concert',
          'Gaming',
          'Sports Event'
        ],
        'amounts': [15, 120],
        'frequency': 12
      },

      // Healthcare
      {
        'category': 'healthcare',
        'titles': [
          'Doctor Visit',
          'Pharmacy',
          'Dental Checkup',
          'Gym Membership',
          'Vitamins'
        ],
        'amounts': [25, 200],
        'frequency': 8
      },
    ];

    // Generate expense transactions
    for (final data in expenseData) {
      final categoryId = data['category'] as String;
      final category = expenseCategories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => expenseCategories.first,
      );

      final titles = data['titles'] as List<String>;
      final amounts = data['amounts'] as List<int>;
      final frequency = data['frequency'] as int;

      for (int i = 0; i < frequency; i++) {
        final expenseDate = now.subtract(Duration(days: random.nextInt(90)));
        final title = titles[random.nextInt(titles.length)];
        final minAmount = amounts[0].toDouble();
        final maxAmount = amounts[1].toDouble();
        final amount =
            minAmount + random.nextDouble() * (maxAmount - minAmount);

        String? description;
        if (random.nextBool()) {
          description = _generateDescription(categoryId, title);
        }

        demoTransactions.add(Transaction(
          id: 'demo_expense_$transactionId',
          title: title,
          amount: double.parse(amount.toStringAsFixed(2)),
          description: description,
          categoryId: category.id,
          date: expenseDate,
          type: TransactionType.expense,
        ));
        transactionId++;
      }
    }

    // Sort transactions by date (newest first)
    demoTransactions.sort((a, b) => b.date.compareTo(a.date));

    // Add all transactions
    for (final transaction in demoTransactions) {
      await transactionService.addTransaction(transaction);
    }

    debugPrint('Loaded ${demoTransactions.length} demo transactions');
  }

  static Future<void> _loadDemoBudgets(
    BudgetService budgetService,
    CategoryService categoryService,
  ) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final expenseCategories = categoryService.expenseCategories;

    final demoBudgets = [
      {
        'name': 'Food & Dining Budget',
        'amount': 800.0,
        'categoryId': 'food',
        'period': BudgetPeriod.monthly,
      },
      {
        'name': 'Transportation Budget',
        'amount': 300.0,
        'categoryId': 'transport',
        'period': BudgetPeriod.monthly,
      },
      {
        'name': 'Shopping Budget',
        'amount': 500.0,
        'categoryId': 'shopping',
        'period': BudgetPeriod.monthly,
      },
      {
        'name': 'Entertainment Budget',
        'amount': 200.0,
        'categoryId': 'entertainment',
        'period': BudgetPeriod.monthly,
      },
      {
        'name': 'Monthly Expenses',
        'amount': 2500.0,
        'categoryId': '', // All categories
        'period': BudgetPeriod.monthly,
      },
    ];

    int budgetId = 1;
    for (final budgetData in demoBudgets) {
      final categoryId = budgetData['categoryId'] as String;

      // Check if category exists (skip if not)
      if (categoryId.isNotEmpty &&
          !expenseCategories.any((c) => c.id == categoryId)) {
        continue;
      }

      final budget = Budget(
        id: 'demo_budget_$budgetId',
        name: budgetData['name'] as String,
        amount: budgetData['amount'] as double,
        categoryId: categoryId,
        period: budgetData['period'] as BudgetPeriod,
        createdDate: now,
        startDate: startOfMonth,
        endDate: endOfMonth,
      );

      await budgetService.addBudget(budget);
      budgetId++;
    }

    debugPrint('Loaded ${demoBudgets.length} demo budgets');
  }

  static String? _generateDescription(String categoryId, String title) {
    final descriptions = {
      'food': [
        'Weekly grocery shopping',
        'Dinner with family',
        'Quick lunch break',
        'Morning coffee routine',
        'Weekend treat'
      ],
      'transport': [
        'Commute to work',
        'Weekend trip',
        'Airport transfer',
        'Regular maintenance',
        'Downtown parking'
      ],
      'bills': [
        'Monthly utility payment',
        'Service subscription',
        'Regular monthly bill',
        'Annual insurance premium',
        'Quarterly payment'
      ],
      'shopping': [
        'Essential household items',
        'New seasonal clothing',
        'Tech upgrade',
        'Home improvement',
        'Personal care items'
      ],
      'entertainment': [
        'Weekend entertainment',
        'Monthly subscription',
        'Live event tickets',
        'Hobby expenses',
        'Social activity'
      ],
      'healthcare': [
        'Regular checkup',
        'Prescription refill',
        'Health maintenance',
        'Fitness investment',
        'Medical consultation'
      ],
    };

    final categoryDescriptions = descriptions[categoryId] ?? ['Transaction'];
    final random = Random();
    return categoryDescriptions[random.nextInt(categoryDescriptions.length)];
  }

  // Method to create sample financial goals (for future use)
  static List<Map<String, dynamic>> getSampleFinancialGoals() {
    return [
      {
        'name': 'Emergency Fund',
        'targetAmount': 10000.0,
        'currentAmount': 3500.0,
        'targetDate': DateTime.now().add(const Duration(days: 365)),
        'description': 'Build emergency fund for 6 months expenses',
      },
      {
        'name': 'Vacation Fund',
        'targetAmount': 5000.0,
        'currentAmount': 1200.0,
        'targetDate': DateTime.now().add(const Duration(days: 180)),
        'description': 'Save for dream vacation to Europe',
      },
      {
        'name': 'New Car',
        'targetAmount': 25000.0,
        'currentAmount': 8000.0,
        'targetDate': DateTime.now().add(const Duration(days: 730)),
        'description': 'Save for a reliable new car',
      },
    ];
  }
}
