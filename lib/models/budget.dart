import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 5)
class Budget extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double amount;

  @HiveField(3)
  double spent;

  @HiveField(4)
  String categoryId;

  @HiveField(5)
  BudgetPeriod period;

  @HiveField(6)
  DateTime startDate;

  @HiveField(7)
  DateTime endDate;

  @HiveField(8)
  bool alertEnabled;

  @HiveField(9)
  double alertPercentage;

  @HiveField(10)
  DateTime createdDate;

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    this.spent = 0.0,
    required this.categoryId,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.alertEnabled = true,
    this.alertPercentage = 80.0,
    required this.createdDate,
  });

  double get remainingAmount => amount - spent;
  double get spentPercentage => (spent / amount) * 100;
  bool get isOverBudget => spent > amount;
  bool get shouldAlert => alertEnabled && spentPercentage >= alertPercentage;

  Budget copyWith({
    String? id,
    String? name,
    double? amount,
    double? spent,
    String? categoryId,
    BudgetPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    bool? alertEnabled,
    double? alertPercentage,
    DateTime? createdDate,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      categoryId: categoryId ?? this.categoryId,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      alertEnabled: alertEnabled ?? this.alertEnabled,
      alertPercentage: alertPercentage ?? this.alertPercentage,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}

@HiveType(typeId: 6)
enum BudgetPeriod {
  @HiveField(0)
  weekly,
  @HiveField(1)
  monthly,
  @HiveField(2)
  yearly,
}
// Commit 22: 2025-02-08T05:21:11
// Commit 48: 2025-02-15T21:23:57
// Commit 156: 2025-03-19T17:47:52
// Commit 163: 2025-03-21T19:18:16
// Commit 22: 2025-02-08T05:06:54
// Commit 77: 2025-02-24T10:32:33
// Commit 174: 2025-03-25T01:45:16
// Commit 13: 2025-02-05T13:39:15
// Commit 28: 2025-02-09T23:48:50
// Commit 45: 2025-02-15T00:10:26
// Commit 67: 2025-02-21T12:07:26
// Commit 94: 2025-03-01T11:14:58
// Commit 107: 2025-03-05T07:10:10
// Commit 122: 2025-03-09T16:49:05
// Commit 137: 2025-03-14T03:21:12
// Commit 139: 2025-03-14T17:43:07
// Commit 145: 2025-03-16T11:44:41
// Commit 151: 2025-03-18T06:51:41
// Commit 169: 2025-03-23T14:18:29
// Commit 11: 2025-02-04T22:53:33
// Commit 20: 2025-02-07T15:13:11
// Commit 70: 2025-02-22T08:57:21
// Commit 76: 2025-02-24T03:43:04
// Commit 122: 2025-03-09T16:43:57
// Commit 130: 2025-03-12T01:45:53
// Commit 178: 2025-03-26T05:43:07
// Commit 17: 2025-02-06T17:52:50
// Commit 26: 2025-02-09T09:54:24
// Commit 28: 2025-02-09T23:14:09
// Commit 44: 2025-02-14T17:04:15
// Commit 46: 2025-02-15T06:51:30
// Commit 48: 2025-02-15T21:04:08
// Commit 49: 2025-02-16T04:40:21
// Commit 109: 2025-03-05T20:58:26
// Commit 128: 2025-03-11T11:28:11
// Commit 141: 2025-03-15T08:06:29
// Commit 168: 2025-03-23T06:43:08
// Commit 173: 2025-03-24T17:51:11
// Commit 177: 2025-03-25T22:44:16
// Commit 188: 2025-03-29T04:24:09
// Commit 8: 2025-02-04T01:58:59
// Commit 17: 2025-02-06T17:44:18
// Commit 32: 2025-02-11T04:00:02
// Commit 34: 2025-02-11T18:23:40
// Commit 81: 2025-02-25T15:02:42
// Commit 98: 2025-03-02T15:00:27
// Commit 122: 2025-03-09T17:29:11
// Commit 131: 2025-03-12T08:49:18
// Commit 137: 2025-03-14T03:19:58
// Commit 163: 2025-03-21T19:33:12
// Commit 178: 2025-03-26T05:47:00
// Commit 179: 2025-03-26T13:01:44
// Commit 46: 2025-02-15T07:08:23
// Commit 65: 2025-02-20T21:44:44
// Commit 98: 2025-03-02T14:46:28
// Commit 119: 2025-03-08T20:13:35
// Commit 167: 2025-03-22T23:44:55
// Commit 169: 2025-03-23T13:55:46
// Commit 170: 2025-03-23T20:53:31
// Commit 175: 2025-03-25T08:07:31
// Commit 183: 2025-03-27T17:26:29
