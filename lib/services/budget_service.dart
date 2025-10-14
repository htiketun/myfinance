import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/budget.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../services/transaction_service.dart';

class BudgetService extends ChangeNotifier {
  final _uuid = const Uuid();
  List<Budget> _budgets = [];

  List<Budget> get budgets => _budgets;
  List<Budget> get activeBudgets =>
      _budgets.where((b) => _isBudgetActive(b)).toList();
  List<Budget> get alertBudgets =>
      _budgets.where((b) => b.shouldAlert).toList();

  BudgetService() {
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    final box = StorageService.budgets;
    _budgets = box.values.toList();
    notifyListeners();
  }

  Future<void> addBudget(Budget budget) async {
    final box = StorageService.budgets;
    await box.put(budget.id, budget);
    _budgets.add(budget);
    notifyListeners();
  }

  Future<void> updateBudget(Budget budget) async {
    final box = StorageService.budgets;
    await box.put(budget.id, budget);

    final index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index != -1) {
      _budgets[index] = budget;
      notifyListeners();
    }
  }

  Future<void> deleteBudget(String id) async {
    final box = StorageService.budgets;
    await box.delete(id);
    _budgets.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  Future<Budget> createBudget({
    required String name,
    required double amount,
    required String categoryId,
    required BudgetPeriod period,
    bool alertEnabled = true,
    double alertPercentage = 80.0,
  }) async {
    final now = DateTime.now();
    final dateRange = _calculateBudgetPeriod(now, period);

    final budget = Budget(
      id: _uuid.v4(),
      name: name,
      amount: amount,
      categoryId: categoryId,
      period: period,
      startDate: dateRange.start,
      endDate: dateRange.end,
      alertEnabled: alertEnabled,
      alertPercentage: alertPercentage,
      createdDate: now,
    );

    await addBudget(budget);
    return budget;
  }

  DateTimeRange _calculateBudgetPeriod(DateTime date, BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.weekly:
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return DateTimeRange(
          start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
          end: DateTime(
              endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
        );

      case BudgetPeriod.monthly:
        final startOfMonth = DateTime(date.year, date.month, 1);
        final endOfMonth = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: startOfMonth, end: endOfMonth);

      case BudgetPeriod.yearly:
        final startOfYear = DateTime(date.year, 1, 1);
        final endOfYear = DateTime(date.year, 12, 31, 23, 59, 59);
        return DateTimeRange(start: startOfYear, end: endOfYear);
    }
  }

  bool _isBudgetActive(Budget budget) {
    final now = DateTime.now();
    return now.isAfter(budget.startDate) && now.isBefore(budget.endDate);
  }

  Future<void> updateBudgetSpending(
      TransactionService transactionService) async {
    for (final budget in _budgets) {
      final transactions = transactionService.getTransactionsForDateRange(
        budget.startDate,
        budget.endDate,
      );

      // Filter transactions based on budget category
      final filteredTransactions = transactions.where((t) {
        // If budget categoryId is empty, include all expense transactions
        if (budget.categoryId.isEmpty) {
          return t.type == TransactionType.expense;
        }
        // Otherwise, only include transactions matching the specific category
        return t.type == TransactionType.expense &&
            t.categoryId == budget.categoryId;
      });

      final spent = filteredTransactions.fold(0.0, (sum, t) => sum + t.amount);

      if (budget.spent != spent) {
        final updatedBudget = budget.copyWith(spent: spent);
        await updateBudget(updatedBudget);
      }
    }
  }

  Future<void> clearAllBudgets() async {
    final box = StorageService.budgets;
    await box.clear();
    _budgets.clear();
    notifyListeners();
  }

  Budget? getBudgetById(String id) {
    try {
      return _budgets.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Budget> getBudgetsByCategory(String categoryId) {
    return _budgets.where((b) => b.categoryId == categoryId).toList();
  }

  double getTotalBudgetAmount() {
    return activeBudgets.fold(0.0, (sum, b) => sum + b.amount);
  }

  double getTotalSpentAmount() {
    return activeBudgets.fold(0.0, (sum, b) => sum + b.spent);
  }

  double getRemainingBudgetAmount() {
    return getTotalBudgetAmount() - getTotalSpentAmount();
  }

  // Check if any budgets need alerts
  List<String> getBudgetAlerts() {
    final alerts = <String>[];

    for (final budget in activeBudgets) {
      if (budget.isOverBudget) {
        alerts.add(
            '${budget.name} is over budget by \K ${(budget.spent - budget.amount).toStringAsFixed(2)}');
      } else if (budget.shouldAlert) {
        alerts.add(
            '${budget.name} has reached ${budget.spentPercentage.toStringAsFixed(0)}% of budget');
      }
    }

    return alerts;
  }

  // Helper method to debug budget spending calculation
  void debugBudgetSpending(TransactionService transactionService) {
    for (final budget in _budgets) {
      final transactions = transactionService.getTransactionsForDateRange(
        budget.startDate,
        budget.endDate,
      );

      print('Budget: ${budget.name}');
      print('Category ID: ${budget.categoryId}');
      print('Date range: ${budget.startDate} to ${budget.endDate}');
      print('Total transactions in range: ${transactions.length}');

      final expenseTransactions =
          transactions.where((t) => t.type == TransactionType.expense).toList();
      print('Expense transactions: ${expenseTransactions.length}');

      if (budget.categoryId.isEmpty) {
        print('Budget applies to all categories');
      } else {
        final categoryTransactions = expenseTransactions
            .where((t) => t.categoryId == budget.categoryId)
            .toList();
        print('Transactions matching category: ${categoryTransactions.length}');
      }
    }
  }
}

