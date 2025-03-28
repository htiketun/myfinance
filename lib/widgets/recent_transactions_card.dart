import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/transaction_service.dart';
import '../services/category_service.dart';
import '../models/transaction.dart';

class RecentTransactionsCard extends StatelessWidget {
  const RecentTransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionService = Provider.of<TransactionService>(context);
    final categoryService = Provider.of<CategoryService>(context);

    final recentTransactions =
        transactionService.getRecentTransactions(limit: 5);

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
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to transactions screen
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recentTransactions.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No transactions yet',
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
                      'Start by adding your first transaction',
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
              ...recentTransactions.map((transaction) =>
                  _buildTransactionItem(context, transaction, categoryService)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    Transaction transaction,
    CategoryService categoryService,
  ) {
    final category = categoryService.getCategoryById(transaction.categoryId);
    final isIncome = transaction.type == TransactionType.income;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: category?.color.withOpacity(0.2) ??
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category?.icon ?? Icons.category,
              color: category?.color ?? Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
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
                '${isIncome ? '+' : '-'}\K ${transaction.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('MMM dd').format(transaction.date),
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
        ],
      ),
    );
  }
}
// Commit 139: 2025-03-14T17:29:03
// Commit 19: 2025-02-07T08:18:34
// Commit 40: 2025-02-13T12:59:07
// Commit 43: 2025-02-14T09:55:04
// Commit 109: 2025-03-05T20:41:50
// Commit 128: 2025-03-11T11:22:34
// Commit 3: 2025-02-02T14:22:03
// Commit 5: 2025-02-03T05:01:21
// Commit 10: 2025-02-04T16:06:39
// Commit 17: 2025-02-06T17:58:50
// Commit 19: 2025-02-07T07:33:36
// Commit 31: 2025-02-10T21:17:27
// Commit 65: 2025-02-20T21:14:29
// Commit 67: 2025-02-21T12:07:26
// Commit 106: 2025-03-05T00:21:48
// Commit 109: 2025-03-05T21:21:56
// Commit 110: 2025-03-06T03:58:32
// Commit 181: 2025-03-27T02:51:44
// Commit 195: 2025-03-31T06:03:51
// Commit 68: 2025-02-21T18:32:10
// Commit 70: 2025-02-22T08:57:21
// Commit 72: 2025-02-22T23:26:34
// Commit 81: 2025-02-25T14:36:32
// Commit 83: 2025-02-26T05:05:17
// Commit 86: 2025-02-27T02:01:23
// Commit 132: 2025-03-12T16:18:03
// Commit 168: 2025-03-23T06:47:21
// Commit 199: 2025-04-01T10:15:56
// Commit 57: 2025-02-18T13:27:51
// Commit 58: 2025-02-18T19:57:14
// Commit 73: 2025-02-23T06:33:19
// Commit 80: 2025-02-25T07:41:50
// Commit 99: 2025-03-02T22:49:28
// Commit 100: 2025-03-03T05:35:30
// Commit 112: 2025-03-06T18:26:03
// Commit 128: 2025-03-11T11:28:11
// Commit 143: 2025-03-15T22:12:45
// Commit 147: 2025-03-17T02:18:08
// Commit 150: 2025-03-17T23:26:40
// Commit 26: 2025-02-09T09:59:22
// Commit 27: 2025-02-09T16:25:05
// Commit 36: 2025-02-12T08:16:51
// Commit 44: 2025-02-14T17:14:04
// Commit 81: 2025-02-25T15:02:42
// Commit 94: 2025-03-01T11:15:14
// Commit 112: 2025-03-06T18:07:37
// Commit 121: 2025-03-09T10:15:41
// Commit 132: 2025-03-12T16:04:20
// Commit 25: 2025-02-09T02:46:28
// Commit 31: 2025-02-10T20:37:50
// Commit 54: 2025-02-17T15:35:57
// Commit 56: 2025-02-18T06:21:56
// Commit 66: 2025-02-21T04:12:10
// Commit 69: 2025-02-22T02:21:26
// Commit 76: 2025-02-24T03:16:36
// Commit 87: 2025-02-27T09:29:48
// Commit 92: 2025-02-28T20:54:52
// Commit 95: 2025-03-01T17:52:45
// Commit 118: 2025-03-08T13:00:21
// Commit 130: 2025-03-12T01:37:42
// Commit 157: 2025-03-20T00:38:24
// Commit 173: 2025-03-24T18:15:23
// Commit 182: 2025-03-27T09:36:33
// Commit 185: 2025-03-28T07:07:02
