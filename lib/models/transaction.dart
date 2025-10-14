import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String categoryId;

  @HiveField(4)
  TransactionType type;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  String? description;

  @HiveField(7)
  String? currency;

  @HiveField(8)
  bool isRecurring;

  @HiveField(9)
  RecurringType? recurringType;

  @HiveField(10)
  DateTime? nextRecurringDate;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.type,
    required this.date,
    this.description,
    this.currency = 'MMK',
    this.isRecurring = false,
    this.recurringType,
    this.nextRecurringDate,
  });

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? categoryId,
    TransactionType? type,
    DateTime? date,
    String? description,
    String? currency,
    bool? isRecurring,
    RecurringType? recurringType,
    DateTime? nextRecurringDate,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      date: date ?? this.date,
      description: description ?? this.description,
      currency: currency ?? this.currency,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringType: recurringType ?? this.recurringType,
      nextRecurringDate: nextRecurringDate ?? this.nextRecurringDate,
    );
  }
}

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 2)
enum RecurringType {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  yearly,
}

