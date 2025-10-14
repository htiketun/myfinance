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

