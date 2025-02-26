import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/transaction_service.dart';
import '../services/budget_service.dart';

class QuickStatsCard extends StatelessWidget {
  const QuickStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionService = Provider.of<TransactionService>(context);
    final budgetService = Provider.of<BudgetService>(context);
    
    final recentTransactions = transactionService.getRecentTransactions(limit: 5);
    final activeBudgets = budgetService.activeBudgets;
    final budgetAlerts = budgetService.getBudgetAlerts();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Transactions',
                    '${recentTransactions.length}',
                    Icons.receipt_long,
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Active Budgets',
                    '${activeBudgets.length}',
                    Icons.account_balance_wallet,
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Alerts',
                    '${budgetAlerts.length}',
                    Icons.warning,
                    budgetAlerts.isNotEmpty ? Colors.orange : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}// Commit 92: 2025-02-28T21:04:27
// Commit 42: 2025-02-14T02:26:12
// Commit 151: 2025-03-18T06:38:04
// Commit 20: 2025-02-07T14:53:19
// Commit 102: 2025-03-03T19:58:20
// Commit 128: 2025-03-11T12:05:33
// Commit 157: 2025-03-20T00:54:47
// Commit 187: 2025-03-28T21:38:08
// Commit 193: 2025-03-30T16:02:07
// Commit 1: 2025-02-02T00:23:35
// Commit 22: 2025-02-08T05:40:26
// Commit 45: 2025-02-14T23:35:04
// Commit 46: 2025-02-15T06:42:00
// Commit 88: 2025-02-27T16:54:05
// Commit 121: 2025-03-09T10:00:41
// Commit 137: 2025-03-14T03:15:28
// Commit 183: 2025-03-27T17:32:38
// Commit 194: 2025-03-30T22:55:57
// Commit 5: 2025-02-03T04:49:55
// Commit 7: 2025-02-03T19:08:55
// Commit 25: 2025-02-09T02:11:58
// Commit 81: 2025-02-25T15:06:03
// Commit 119: 2025-03-08T19:38:26
// Commit 159: 2025-03-20T15:13:26
// Commit 197: 2025-03-31T19:53:20
// Commit 7: 2025-02-03T19:26:33
// Commit 57: 2025-02-18T13:20:31
// Commit 69: 2025-02-22T01:28:47
// Commit 127: 2025-03-11T04:41:31
// Commit 129: 2025-03-11T18:49:47
// Commit 147: 2025-03-17T02:04:42
// Commit 159: 2025-03-20T15:05:27
// Commit 182: 2025-03-27T09:29:07
// Commit 200: 2025-04-01T17:06:08
// Commit 47: 2025-02-15T14:08:05
// Commit 74: 2025-02-23T13:19:14
// Commit 81: 2025-02-25T15:01:07
// Commit 85: 2025-02-26T18:56:16
