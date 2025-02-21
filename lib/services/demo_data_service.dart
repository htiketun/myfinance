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
// Commit 96: 2025-03-02T00:41:22
// Commit 168: 2025-03-23T07:19:33
// Commit 176: 2025-03-25T15:50:04
// Commit 61: 2025-02-19T17:06:39
// Commit 145: 2025-03-16T11:33:50
// Commit 77: 2025-02-24T10:22:07
// Commit 83: 2025-02-26T05:21:50
// Commit 99: 2025-03-02T21:50:27
// Commit 103: 2025-03-04T02:53:27
// Commit 153: 2025-03-18T20:40:10
// Commit 176: 2025-03-25T15:46:22
// Commit 196: 2025-03-31T13:32:42
// Commit 11: 2025-02-04T22:53:33
// Commit 12: 2025-02-05T06:36:23
// Commit 23: 2025-02-08T12:28:02
// Commit 26: 2025-02-09T09:46:58
// Commit 30: 2025-02-10T13:52:31
// Commit 33: 2025-02-11T10:59:44
// Commit 36: 2025-02-12T08:01:32
// Commit 40: 2025-02-13T12:59:38
// Commit 45: 2025-02-14T23:35:04
// Commit 51: 2025-02-16T18:23:39
// Commit 54: 2025-02-17T15:23:35
// Commit 57: 2025-02-18T12:47:03
// Commit 88: 2025-02-27T16:54:05
// Commit 91: 2025-02-28T13:42:29
// Commit 96: 2025-03-02T00:41:46
// Commit 107: 2025-03-05T07:04:06
// Commit 131: 2025-03-12T09:00:41
// Commit 136: 2025-03-13T20:15:12
// Commit 144: 2025-03-16T04:31:40
// Commit 152: 2025-03-18T13:41:40
// Commit 160: 2025-03-20T22:37:58
// Commit 161: 2025-03-21T05:32:24
// Commit 183: 2025-03-27T17:32:38
// Commit 185: 2025-03-28T07:09:14
// Commit 193: 2025-03-30T15:42:20
// Commit 8: 2025-02-04T01:43:46
// Commit 65: 2025-02-20T21:12:05
// Commit 73: 2025-02-23T06:33:19
// Commit 76: 2025-02-24T03:19:50
// Commit 102: 2025-03-03T19:27:00
// Commit 108: 2025-03-05T13:57:54
// Commit 110: 2025-03-06T04:37:56
// Commit 118: 2025-03-08T12:50:50
// Commit 120: 2025-03-09T02:54:36
// Commit 122: 2025-03-09T17:40:18
// Commit 125: 2025-03-10T14:18:47
// Commit 140: 2025-03-15T00:43:34
// Commit 143: 2025-03-15T22:12:45
// Commit 154: 2025-03-19T03:25:45
// Commit 158: 2025-03-20T07:37:18
// Commit 160: 2025-03-20T21:57:28
// Commit 162: 2025-03-21T12:40:24
// Commit 200: 2025-04-01T17:40:47
// Commit 7: 2025-02-03T19:26:33
// Commit 16: 2025-02-06T10:50:05
// Commit 19: 2025-02-07T08:03:37
// Commit 51: 2025-02-16T18:14:52
// Commit 54: 2025-02-17T15:58:35
// Commit 56: 2025-02-18T05:56:29
// Commit 64: 2025-02-20T14:04:55
// Commit 74: 2025-02-23T12:54:18
// Commit 98: 2025-03-02T15:00:27
// Commit 113: 2025-03-07T01:55:49
// Commit 116: 2025-03-07T23:06:55
// Commit 137: 2025-03-14T03:19:58
// Commit 138: 2025-03-14T10:43:31
// Commit 150: 2025-03-17T23:25:45
// Commit 164: 2025-03-22T02:22:58
// Commit 165: 2025-03-22T09:48:35
// Commit 172: 2025-03-24T10:41:17
// Commit 181: 2025-03-27T03:13:03
// Commit 30: 2025-02-10T13:21:35
// Commit 33: 2025-02-11T11:21:49
// Commit 35: 2025-02-12T01:27:43
// Commit 45: 2025-02-15T00:19:14
// Commit 58: 2025-02-18T20:06:21
// Commit 66: 2025-02-21T04:12:10
