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
// Commit 63: 2025-02-20T07:44:09
// Commit 87: 2025-02-27T08:56:31
// Commit 143: 2025-03-15T22:05:40
// Commit 147: 2025-03-17T02:26:04
// Commit 148: 2025-03-17T09:19:40
// Commit 149: 2025-03-17T16:39:22
// Commit 194: 2025-03-30T23:24:30
// Commit 17: 2025-02-06T17:18:19
// Commit 90: 2025-02-28T06:08:40
// Commit 114: 2025-03-07T08:15:43
// Commit 200: 2025-04-01T16:57:49
// Commit 2: 2025-02-02T07:29:01
// Commit 18: 2025-02-07T00:37:57
// Commit 33: 2025-02-11T11:12:02
// Commit 58: 2025-02-18T20:07:00
// Commit 60: 2025-02-19T10:14:31
// Commit 68: 2025-02-21T18:50:13
// Commit 69: 2025-02-22T02:15:19
// Commit 72: 2025-02-22T23:15:26
// Commit 73: 2025-02-23T06:27:02
// Commit 94: 2025-03-01T11:14:58
// Commit 98: 2025-03-02T15:44:55
// Commit 106: 2025-03-05T00:21:48
// Commit 112: 2025-03-06T18:49:30
// Commit 131: 2025-03-12T08:37:49
// Commit 133: 2025-03-12T23:05:44
// Commit 141: 2025-03-15T07:23:23
// Commit 145: 2025-03-16T11:44:41
// Commit 159: 2025-03-20T14:45:18
// Commit 166: 2025-03-22T16:58:56
// Commit 167: 2025-03-22T23:28:20
// Commit 182: 2025-03-27T09:48:02
// Commit 194: 2025-03-30T22:43:01
// Commit 199: 2025-04-01T10:46:28
// Commit 200: 2025-04-01T17:02:05
// Commit 7: 2025-02-03T18:41:03
// Commit 43: 2025-02-14T09:34:18
// Commit 53: 2025-02-17T08:13:40
// Commit 58: 2025-02-18T20:30:42
// Commit 69: 2025-02-22T01:56:49
// Commit 77: 2025-02-24T10:28:37
// Commit 82: 2025-02-25T22:06:36
// Commit 92: 2025-02-28T20:32:11
// Commit 121: 2025-03-09T10:00:41
// Commit 145: 2025-03-16T12:29:17
// Commit 157: 2025-03-20T00:48:15
// Commit 164: 2025-03-22T02:28:41
// Commit 176: 2025-03-25T15:44:32
// Commit 181: 2025-03-27T03:05:21
// Commit 191: 2025-03-30T02:10:08
// Commit 192: 2025-03-30T08:24:42
// Commit 27: 2025-02-09T16:28:40
// Commit 77: 2025-02-24T10:38:50
// Commit 90: 2025-02-28T07:04:25
// Commit 109: 2025-03-05T20:58:26
// Commit 126: 2025-03-10T21:48:50
// Commit 129: 2025-03-11T18:29:32
// Commit 134: 2025-03-13T05:56:18
// Commit 156: 2025-03-19T17:54:45
// Commit 168: 2025-03-23T06:43:08
// Commit 181: 2025-03-27T03:08:41
// Commit 187: 2025-03-28T21:04:57
// Commit 189: 2025-03-29T11:49:35
// Commit 8: 2025-02-04T01:58:59
// Commit 11: 2025-02-04T23:35:52
// Commit 14: 2025-02-05T20:34:13
// Commit 23: 2025-02-08T12:26:21
// Commit 40: 2025-02-13T12:14:52
// Commit 50: 2025-02-16T11:42:52
// Commit 58: 2025-02-18T20:33:30
// Commit 67: 2025-02-21T11:56:13
// Commit 68: 2025-02-21T18:35:52
// Commit 71: 2025-02-22T15:56:20
// Commit 88: 2025-02-27T16:00:14
// Commit 118: 2025-03-08T13:20:10
// Commit 119: 2025-03-08T19:56:18
// Commit 128: 2025-03-11T11:30:28
// Commit 144: 2025-03-16T05:20:09
// Commit 156: 2025-03-19T18:20:16
// Commit 162: 2025-03-21T12:11:29
// Commit 167: 2025-03-22T23:37:12
// Commit 184: 2025-03-27T23:48:40
// Commit 185: 2025-03-28T07:00:15
// Commit 186: 2025-03-28T14:40:54
// Commit 193: 2025-03-30T16:21:15
// Commit 199: 2025-04-01T09:57:49
// Commit 11: 2025-02-04T23:07:22
// Commit 15: 2025-02-06T03:13:16
// Commit 37: 2025-02-12T15:48:49
// Commit 39: 2025-02-13T05:11:03
// Commit 46: 2025-02-15T07:08:23
// Commit 47: 2025-02-15T14:08:05
// Commit 51: 2025-02-16T18:32:59
// Commit 74: 2025-02-23T13:19:14
// Commit 101: 2025-03-03T12:38:52
// Commit 126: 2025-03-10T21:49:04
// Commit 128: 2025-03-11T11:25:26
