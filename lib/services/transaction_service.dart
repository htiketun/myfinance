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

