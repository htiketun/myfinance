import 'package:hive/hive.dart';

part 'financial_goal.g.dart';

@HiveType(typeId: 7)
class FinancialGoal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double targetAmount;

  @HiveField(3)
  double currentAmount;

  @HiveField(4)
  DateTime targetDate;

  @HiveField(5)
  DateTime createdDate;

  @HiveField(6)
  String? description;

  @HiveField(7)
  GoalType type;

  @HiveField(8)
  int colorValue;

  FinancialGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.targetDate,
    required this.createdDate,
    this.description,
    required this.type,
    required this.colorValue,
  });

  double get progressPercentage => (currentAmount / targetAmount) * 100;
  double get remainingAmount => targetAmount - currentAmount;
  bool get isCompleted => currentAmount >= targetAmount;

  int get daysRemaining {
    final now = DateTime.now();
    if (targetDate.isBefore(now)) return 0;
    return targetDate.difference(now).inDays;
  }

  FinancialGoal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    DateTime? createdDate,
    String? description,
    GoalType? type,
    int? colorValue,
  }) {
    return FinancialGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      createdDate: createdDate ?? this.createdDate,
      description: description ?? this.description,
      type: type ?? this.type,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}

@HiveType(typeId: 8)
enum GoalType {
  @HiveField(0)
  savings,
  @HiveField(1)
  investment,
  @HiveField(2)
  debtPayoff,
  @HiveField(3)
  purchase,
  @HiveField(4)
  emergency,
}
// Commit 13: 2025-02-05T13:20:13
// Commit 76: 2025-02-24T03:26:49
// Commit 109: 2025-03-05T21:00:23
// Commit 114: 2025-03-07T08:38:17
// Commit 44: 2025-02-14T16:36:14
// Commit 172: 2025-03-24T11:00:04
// Commit 5: 2025-02-03T05:01:21
// Commit 11: 2025-02-04T22:49:25
// Commit 14: 2025-02-05T20:40:21
// Commit 18: 2025-02-07T00:37:57
// Commit 44: 2025-02-14T16:38:49
// Commit 69: 2025-02-22T02:15:19
// Commit 97: 2025-03-02T08:27:38
// Commit 104: 2025-03-04T10:05:22
// Commit 158: 2025-03-20T08:15:43
// Commit 171: 2025-03-24T04:14:07
// Commit 180: 2025-03-26T20:08:25
// Commit 187: 2025-03-28T21:38:08
// Commit 5: 2025-02-03T04:30:31
// Commit 18: 2025-02-07T00:29:01
// Commit 21: 2025-02-07T21:54:04
// Commit 73: 2025-02-23T06:07:34
// Commit 77: 2025-02-24T10:28:37
// Commit 81: 2025-02-25T14:36:32
// Commit 95: 2025-03-01T18:27:57
// Commit 113: 2025-03-07T00:59:03
// Commit 135: 2025-03-13T12:51:00
// Commit 138: 2025-03-14T10:42:59
// Commit 164: 2025-03-22T02:28:41
// Commit 168: 2025-03-23T06:47:21
// Commit 169: 2025-03-23T14:02:27
// Commit 171: 2025-03-24T04:04:37
// Commit 197: 2025-03-31T19:41:08
// Commit 3: 2025-02-02T14:24:06
// Commit 88: 2025-02-27T16:18:42
// Commit 93: 2025-03-01T04:06:24
// Commit 110: 2025-03-06T04:37:56
// Commit 152: 2025-03-18T13:24:51
// Commit 174: 2025-03-25T01:38:31
// Commit 181: 2025-03-27T03:08:41
// Commit 87: 2025-02-27T09:22:18
// Commit 94: 2025-03-01T11:15:14
// Commit 115: 2025-03-07T15:43:07
// Commit 140: 2025-03-15T00:27:29
// Commit 142: 2025-03-15T14:38:52
// Commit 149: 2025-03-17T15:53:43
// Commit 198: 2025-04-01T03:23:27
