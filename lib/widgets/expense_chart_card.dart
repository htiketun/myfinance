import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/transaction_service.dart';
import '../services/category_service.dart';

class ExpenseChartCard extends StatelessWidget {
  const ExpenseChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionService = Provider.of<TransactionService>(context);
    final categoryService = Provider.of<CategoryService>(context);

    final expensesByCategory = transactionService.getExpensesByCategory();

    if (expensesByCategory.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expense Breakdown',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.pie_chart_outline,
                      size: 48,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No expense data',
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
                      'Add some expenses to see the breakdown',
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
              ),
            ],
          ),
        ),
      );
    }

    final pieChartData =
        _generatePieChartData(expensesByCategory, categoryService);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense Breakdown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sections: pieChartData,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                        startDegreeOffset: -90,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildLegend(
                        context, expensesByCategory, categoryService),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generatePieChartData(
    Map<String, double> expensesByCategory,
    CategoryService categoryService,
  ) {
    final totalExpenses =
        expensesByCategory.values.fold(0.0, (sum, amount) => sum + amount);

    return expensesByCategory.entries.map((entry) {
      final category = categoryService.getCategoryById(entry.key);
      final percentage = (entry.value / totalExpenses) * 100;

      return PieChartSectionData(
        color: category?.color ?? Colors.grey,
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(
    BuildContext context,
    Map<String, double> expensesByCategory,
    CategoryService categoryService,
  ) {
    final sortedEntries = expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedEntries.take(5).map((entry) {
        final category = categoryService.getCategoryById(entry.key);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: category?.color ?? Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category?.name ?? 'Unknown',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\K ${entry.value.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
// Commit 44: 2025-02-14T16:52:33
// Commit 170: 2025-03-23T21:20:49
// Commit 30: 2025-02-10T13:21:14
// Commit 134: 2025-03-13T06:30:47
// Commit 153: 2025-03-18T20:41:38
// Commit 43: 2025-02-14T10:16:12
// Commit 86: 2025-02-27T02:30:19
// Commit 93: 2025-03-01T04:01:42
// Commit 151: 2025-03-18T06:51:41
// Commit 44: 2025-02-14T17:26:08
// Commit 56: 2025-02-18T06:10:29
// Commit 66: 2025-02-21T04:58:28
// Commit 78: 2025-02-24T17:53:23
// Commit 118: 2025-03-08T12:38:07
// Commit 173: 2025-03-24T18:07:15
// Commit 36: 2025-02-12T08:12:27
// Commit 103: 2025-03-04T02:45:09
// Commit 111: 2025-03-06T11:10:29
// Commit 135: 2025-03-13T13:13:33
// Commit 146: 2025-03-16T18:51:00
// Commit 153: 2025-03-18T20:58:34
// Commit 18: 2025-02-07T00:42:18
// Commit 35: 2025-02-12T00:58:18
// Commit 37: 2025-02-12T14:55:58
// Commit 80: 2025-02-25T08:11:57
// Commit 83: 2025-02-26T04:49:57
// Commit 92: 2025-02-28T21:06:58
// Commit 116: 2025-03-07T23:06:55
// Commit 184: 2025-03-27T23:48:40
// Commit 191: 2025-03-30T01:34:25
// Commit 9: 2025-02-04T08:43:21
// Commit 10: 2025-02-04T15:52:23
// Commit 15: 2025-02-06T03:13:16
// Commit 32: 2025-02-11T03:58:36
// Commit 38: 2025-02-12T22:33:18
// Commit 65: 2025-02-20T21:44:44
// Commit 70: 2025-02-22T08:54:46
// Commit 97: 2025-03-02T08:02:36
// Commit 155: 2025-03-19T10:51:00
