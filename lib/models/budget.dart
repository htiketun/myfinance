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

