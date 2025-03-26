import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';

class TransactionService extends ChangeNotifier {
  final _uuid = const Uuid();
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  String _searchQuery = '';
  String? _filterCategoryId;
  TransactionType? _filterType;
  DateTimeRange? _filterDateRange;

  List<Transaction> get transactions => _filteredTransactions;
  List<Transaction> get allTransactions => _transactions;
  String get searchQuery => _searchQuery;
  String? get filterCategoryId => _filterCategoryId;
  TransactionType? get filterType => _filterType;
  DateTimeRange? get filterDateRange => _filterDateRange;

  TransactionService() {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final box = StorageService.transactions;
    _transactions = box.values.toList();
    _applyFilters();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final box = StorageService.transactions;
    await box.put(transaction.id, transaction);
    _transactions.add(transaction);
    _applyFilters();
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final box = StorageService.transactions;
    await box.put(transaction.id, transaction);

    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      _applyFilters();
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    final box = StorageService.transactions;
    await box.delete(id);
    _transactions.removeWhere((t) => t.id == id);
    _applyFilters();
    notifyListeners();
  }

  Future<Transaction> createTransaction({
    required String title,
    required double amount,
    required String categoryId,
    required TransactionType type,
    required DateTime date,
    String? description,
    String currency = 'MMK',
    bool isRecurring = false,
    RecurringType? recurringType,
  }) async {
    final transaction = Transaction(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      categoryId: categoryId,
      type: type,
      date: date,
      description: description,
      currency: currency,
      isRecurring: isRecurring,
      recurringType: recurringType,
      nextRecurringDate: isRecurring
          ? _calculateNextRecurringDate(date, recurringType!)
          : null,
    );

    await addTransaction(transaction);
    return transaction;
  }

  DateTime _calculateNextRecurringDate(DateTime startDate, RecurringType type) {
    switch (type) {
      case RecurringType.daily:
        return startDate.add(const Duration(days: 1));
      case RecurringType.weekly:
        return startDate.add(const Duration(days: 7));
      case RecurringType.monthly:
        return DateTime(startDate.year, startDate.month + 1, startDate.day);
      case RecurringType.yearly:
        return DateTime(startDate.year + 1, startDate.month, startDate.day);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setCategoryFilter(String? categoryId) {
    _filterCategoryId = categoryId;
    _applyFilters();
    notifyListeners();
  }

  void setTypeFilter(TransactionType? type) {
    _filterType = type;
    _applyFilters();
    notifyListeners();
  }

  void setDateRangeFilter(DateTimeRange? dateRange) {
    _filterDateRange = dateRange;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterCategoryId = null;
    _filterType = null;
    _filterDateRange = null;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredTransactions = _transactions.where((transaction) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        if (!transaction.title.toLowerCase().contains(searchLower) &&
            !(transaction.description?.toLowerCase().contains(searchLower) ??
                false)) {
          return false;
        }
      }

      // Category filter
      if (_filterCategoryId != null &&
          transaction.categoryId != _filterCategoryId) {
        return false;
      }

      // Type filter
      if (_filterType != null && transaction.type != _filterType) {
        return false;
      }

      // Date range filter
      if (_filterDateRange != null) {
        final transactionDate = DateTime(
          transaction.date.year,
          transaction.date.month,
          transaction.date.day,
        );
        if (!_isDateInRange(transactionDate, _filterDateRange!)) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort by date (newest first)
    _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
  }

  bool _isDateInRange(DateTime date, DateTimeRange range) {
    final startDate =
        DateTime(range.start.year, range.start.month, range.start.day);
    final endDate = DateTime(range.end.year, range.end.month, range.end.day);
    return date.isAtSameMomentAs(startDate) ||
        date.isAtSameMomentAs(endDate) ||
        (date.isAfter(startDate) && date.isBefore(endDate));
  }

  // Analytics methods
  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get balance => totalIncome - totalExpenses;

  Map<String, double> getExpensesByCategory() {
    final expenses = <String, double>{};
    for (final transaction
        in _transactions.where((t) => t.type == TransactionType.expense)) {
      expenses[transaction.categoryId] =
          (expenses[transaction.categoryId] ?? 0) + transaction.amount;
    }
    return expenses;
  }

  Map<String, double> getIncomeByCategory() {
    final income = <String, double>{};
    for (final transaction
        in _transactions.where((t) => t.type == TransactionType.income)) {
      income[transaction.categoryId] =
          (income[transaction.categoryId] ?? 0) + transaction.amount;
    }
    return income;
  }

  List<Transaction> getTransactionsForDateRange(DateTime start, DateTime end) {
    return _transactions.where((t) {
      return t.date.isAfter(start.subtract(const Duration(days: 1))) &&
          t.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  List<Transaction> getRecentTransactions({int limit = 10}) {
    final sorted = List<Transaction>.from(_transactions);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  Future<void> clearAllTransactions() async {
    final box = StorageService.transactions;
    await box.clear();
    _transactions.clear();
    _applyFilters();
    notifyListeners();
  }
}
// Commit 18: 2025-02-07T00:51:52
// Commit 28: 2025-02-09T23:27:26
// Commit 88: 2025-02-27T16:42:07
// Commit 105: 2025-03-04T16:30:11
// Commit 150: 2025-03-17T23:35:05
// Commit 151: 2025-03-18T06:38:17
// Commit 193: 2025-03-30T16:01:23
// Commit 53: 2025-02-17T08:12:13
// Commit 132: 2025-03-12T15:38:36
// Commit 141: 2025-03-15T07:24:31
// Commit 149: 2025-03-17T16:48:09
// Commit 196: 2025-03-31T12:57:03
// Commit 11: 2025-02-04T22:49:25
// Commit 35: 2025-02-12T01:40:36
// Commit 49: 2025-02-16T04:42:04
// Commit 62: 2025-02-20T00:23:51
// Commit 66: 2025-02-21T04:51:54
// Commit 74: 2025-02-23T13:18:53
// Commit 82: 2025-02-25T21:44:55
// Commit 84: 2025-02-26T11:42:21
// Commit 91: 2025-02-28T13:34:03
// Commit 104: 2025-03-04T10:05:22
// Commit 108: 2025-03-05T14:09:17
// Commit 116: 2025-03-07T23:02:58
// Commit 129: 2025-03-11T19:01:53
// Commit 132: 2025-03-12T15:32:53
// Commit 162: 2025-03-21T12:36:12
// Commit 173: 2025-03-24T18:10:58
// Commit 197: 2025-03-31T20:08:08
// Commit 3: 2025-02-02T15:03:35
// Commit 48: 2025-02-15T21:21:15
// Commit 61: 2025-02-19T17:38:17
// Commit 75: 2025-02-23T20:49:30
// Commit 95: 2025-03-01T18:27:57
// Commit 109: 2025-03-05T21:01:00
// Commit 115: 2025-03-07T15:17:53
// Commit 118: 2025-03-08T12:38:07
// Commit 120: 2025-03-09T03:13:45
// Commit 138: 2025-03-14T10:42:59
// Commit 149: 2025-03-17T16:47:48
// Commit 155: 2025-03-19T10:55:29
// Commit 165: 2025-03-22T10:03:33
// Commit 167: 2025-03-22T23:56:59
// Commit 168: 2025-03-23T06:47:21
// Commit 196: 2025-03-31T13:31:06
// Commit 9: 2025-02-04T09:01:44
// Commit 17: 2025-02-06T17:52:50
// Commit 19: 2025-02-07T07:33:24
// Commit 32: 2025-02-11T03:29:16
// Commit 40: 2025-02-13T13:02:39
// Commit 103: 2025-03-04T02:45:09
// Commit 177: 2025-03-25T22:44:16
// Commit 32: 2025-02-11T04:00:02
// Commit 36: 2025-02-12T08:16:51
// Commit 38: 2025-02-12T22:34:13
// Commit 39: 2025-02-13T05:20:58
// Commit 44: 2025-02-14T17:14:04
// Commit 62: 2025-02-19T23:56:58
// Commit 102: 2025-03-03T19:57:12
// Commit 108: 2025-03-05T13:42:48
// Commit 111: 2025-03-06T11:46:14
// Commit 126: 2025-03-10T21:30:47
// Commit 157: 2025-03-20T00:43:04
// Commit 169: 2025-03-23T14:18:00
// Commit 170: 2025-03-23T20:51:14
// Commit 178: 2025-03-26T05:47:00
// Commit 9: 2025-02-04T08:43:21
// Commit 21: 2025-02-07T21:55:30
// Commit 49: 2025-02-16T04:22:04
// Commit 68: 2025-02-21T18:23:06
// Commit 78: 2025-02-24T17:56:32
// Commit 84: 2025-02-26T12:35:29
// Commit 89: 2025-02-27T23:05:24
// Commit 97: 2025-03-02T08:02:36
// Commit 99: 2025-03-02T22:18:57
// Commit 102: 2025-03-03T20:00:42
// Commit 142: 2025-03-15T15:07:01
// Commit 153: 2025-03-18T21:05:43
// Commit 174: 2025-03-25T01:03:02
// Commit 180: 2025-03-26T20:18:50
