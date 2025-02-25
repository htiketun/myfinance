import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/budget_service.dart';
import '../services/category_service.dart';

class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetService = Provider.of<BudgetService>(context);
    final categoryService = Provider.of<CategoryService>(context);

    final activeBudgets = budgetService.activeBudgets;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget Progress',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to budgets screen
                  },
                  child: const Text('Manage'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (activeBudgets.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 48,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No active budgets',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.6),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first budget to track spending',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.5),
                          ),
                    ),
                  ],
                ),
              )
            else
              ...activeBudgets.take(3).map((budget) =>
                  _buildBudgetItem(context, budget, categoryService)),
            if (activeBudgets.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+ ${activeBudgets.length - 3} more budgets',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetItem(
    BuildContext context,
    budget,
    CategoryService categoryService,
  ) {
    final category = categoryService.getCategoryById(budget.categoryId);
    final progress = budget.spentPercentage / 100;
    final isOverBudget = budget.isOverBudget;
    final shouldAlert = budget.shouldAlert;

    Color progressColor = Theme.of(context).colorScheme.primary;
    if (isOverBudget) {
      progressColor = Colors.red;
    } else if (shouldAlert) {
      progressColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: progressColor.withOpacity(0.3),
        ),
        color: progressColor.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: category?.color.withOpacity(0.2) ??
                      progressColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  category?.icon ?? Icons.category,
                  color: category?.color ?? progressColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      category?.name ?? 'Unknown Category',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\K ${budget.spent.toStringAsFixed(0)} / \K ${budget.amount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: progressColor,
                        ),
                  ),
                  if (isOverBudget || shouldAlert)
                    Icon(
                      isOverBudget ? Icons.error : Icons.warning,
                      color: progressColor,
                      size: 16,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${progress.clamp(0.0, 1.0) * 100}% used',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '\K ${budget.remainingAmount.toStringAsFixed(0)} remaining',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isOverBudget ? Colors.red : null,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: progressColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// Commit 80: 2025-02-25T07:44:25
// Commit 2: 2025-02-02T07:23:44
// Commit 165: 2025-03-22T09:47:06
// Commit 176: 2025-03-25T15:40:59
// Commit 7: 2025-02-03T19:12:02
// Commit 9: 2025-02-04T09:18:34
// Commit 25: 2025-02-09T02:03:35
// Commit 34: 2025-02-11T17:59:56
// Commit 38: 2025-02-12T22:24:24
// Commit 47: 2025-02-15T13:58:31
// Commit 52: 2025-02-17T01:28:02
// Commit 83: 2025-02-26T05:21:50
// Commit 104: 2025-03-04T10:05:22
// Commit 144: 2025-03-16T05:08:24
// Commit 147: 2025-03-17T02:30:24
// Commit 158: 2025-03-20T08:15:43
// Commit 182: 2025-03-27T09:48:02
// Commit 192: 2025-03-30T08:27:54
// Commit 3: 2025-02-02T15:03:35
// Commit 91: 2025-02-28T13:42:29
// Commit 156: 2025-03-19T18:21:03
// Commit 165: 2025-03-22T10:03:33
// Commit 197: 2025-03-31T19:41:08
// Commit 15: 2025-02-06T03:26:49
// Commit 17: 2025-02-06T17:52:50
// Commit 61: 2025-02-19T17:45:55
// Commit 91: 2025-02-28T13:28:53
// Commit 97: 2025-03-02T08:21:04
// Commit 105: 2025-03-04T16:33:59
// Commit 124: 2025-03-10T07:28:58
// Commit 141: 2025-03-15T08:06:29
// Commit 169: 2025-03-23T14:24:58
// Commit 170: 2025-03-23T21:20:38
// Commit 171: 2025-03-24T04:30:03
// Commit 193: 2025-03-30T15:35:39
// Commit 1: 2025-02-02T00:54:58
// Commit 16: 2025-02-06T10:50:05
// Commit 24: 2025-02-08T19:16:27
// Commit 46: 2025-02-15T07:15:22
// Commit 73: 2025-02-23T06:24:19
// Commit 82: 2025-02-25T22:05:47
// Commit 123: 2025-03-09T23:50:22
// Commit 134: 2025-03-13T06:05:49
// Commit 148: 2025-03-17T08:56:06
// Commit 150: 2025-03-17T23:25:45
// Commit 154: 2025-03-19T03:22:27
// Commit 189: 2025-03-29T11:03:01
// Commit 17: 2025-02-06T18:06:43
// Commit 43: 2025-02-14T09:44:28
// Commit 78: 2025-02-24T17:56:32
// Commit 79: 2025-02-25T01:09:11
