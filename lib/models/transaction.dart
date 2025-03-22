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
// Commit 43: 2025-02-14T09:38:56
// Commit 45: 2025-02-15T00:29:48
// Commit 71: 2025-02-22T16:17:06
// Commit 88: 2025-02-27T16:50:28
// Commit 185: 2025-03-28T07:27:11
// Commit 198: 2025-04-01T03:34:00
// Commit 30: 2025-02-10T14:16:14
// Commit 34: 2025-02-11T17:59:56
// Commit 42: 2025-02-14T03:04:16
// Commit 48: 2025-02-15T21:40:29
// Commit 88: 2025-02-27T16:06:28
// Commit 102: 2025-03-03T19:58:20
// Commit 105: 2025-03-04T16:34:37
// Commit 111: 2025-03-06T11:25:58
// Commit 138: 2025-03-14T10:38:16
// Commit 164: 2025-03-22T02:28:09
// Commit 189: 2025-03-29T11:12:33
// Commit 196: 2025-03-31T13:32:42
// Commit 8: 2025-02-04T01:53:48
// Commit 50: 2025-02-16T11:45:28
// Commit 53: 2025-02-17T08:13:40
// Commit 60: 2025-02-19T10:06:23
// Commit 67: 2025-02-21T11:51:47
// Commit 72: 2025-02-22T23:26:34
// Commit 87: 2025-02-27T09:12:45
// Commit 108: 2025-03-05T14:28:12
// Commit 117: 2025-03-08T06:13:26
// Commit 127: 2025-03-11T05:03:29
// Commit 136: 2025-03-13T20:15:12
// Commit 152: 2025-03-18T13:41:40
// Commit 167: 2025-03-22T23:56:59
// Commit 186: 2025-03-28T13:55:03
// Commit 192: 2025-03-30T08:24:42
// Commit 200: 2025-04-01T17:28:52
// Commit 18: 2025-02-07T01:12:08
// Commit 29: 2025-02-10T06:33:55
// Commit 35: 2025-02-12T01:42:45
// Commit 37: 2025-02-12T15:16:28
// Commit 38: 2025-02-12T22:06:01
// Commit 42: 2025-02-14T02:26:41
// Commit 43: 2025-02-14T10:19:24
// Commit 51: 2025-02-16T18:46:16
// Commit 62: 2025-02-20T00:48:33
// Commit 76: 2025-02-24T03:19:50
// Commit 79: 2025-02-25T00:45:06
// Commit 95: 2025-03-01T17:54:27
// Commit 106: 2025-03-05T00:22:59
// Commit 122: 2025-03-09T17:40:18
// Commit 136: 2025-03-13T20:31:45
// Commit 145: 2025-03-16T11:39:48
// Commit 151: 2025-03-18T06:34:57
// Commit 156: 2025-03-19T17:54:45
// Commit 158: 2025-03-20T07:37:18
// Commit 172: 2025-03-24T11:08:07
// Commit 3: 2025-02-02T15:00:07
// Commit 23: 2025-02-08T12:26:21
// Commit 24: 2025-02-08T19:16:27
// Commit 31: 2025-02-10T21:15:01
// Commit 45: 2025-02-14T23:33:10
// Commit 46: 2025-02-15T07:15:22
// Commit 63: 2025-02-20T07:35:35
// Commit 133: 2025-03-12T23:26:40
// Commit 136: 2025-03-13T20:06:37
// Commit 164: 2025-03-22T02:22:58
// Commit 195: 2025-03-31T05:34:15
// Commit 2: 2025-02-02T07:32:05
// Commit 32: 2025-02-11T03:58:36
// Commit 34: 2025-02-11T17:53:38
// Commit 48: 2025-02-15T21:39:40
// Commit 62: 2025-02-20T00:46:00
// Commit 82: 2025-02-25T21:45:01
// Commit 115: 2025-03-07T15:12:31
// Commit 136: 2025-03-13T20:05:31
// Commit 137: 2025-03-14T03:52:46
// Commit 154: 2025-03-19T04:03:26
// Commit 160: 2025-03-20T22:22:13
// Commit 165: 2025-03-22T09:32:23
