import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/category_service.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);
    final category = categoryService.getCategoryById(transaction.categoryId);
    final isIncome = transaction.type == TransactionType.income;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    (category?.color ?? Theme.of(context).colorScheme.primary)
                        .withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Category Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (category?.color ??
                            Theme.of(context).colorScheme.primary)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    category?.icon ?? Icons.category,
                    color: category?.color ??
                        Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Transaction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              transaction.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (transaction.isRecurring)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Recurring',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            category?.name ?? 'Unknown Category',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withOpacity(0.6),
                                    ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMM dd, yyyy').format(transaction.date),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withOpacity(0.6),
                                    ),
                          ),
                        ],
                      ),
                      if (transaction.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          transaction.description!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withOpacity(0.7),
                                    fontStyle: FontStyle.italic,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isIncome ? '+' : '-'}${transaction.currency ?? '\K '}${transaction.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isIncome ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isIncome
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isIncome ? 'Income' : 'Expense',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isIncome ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Commit 68: 2025-02-21T18:37:34
// Commit 99: 2025-03-02T22:09:20
// Commit 124: 2025-03-10T07:28:06
// Commit 128: 2025-03-11T11:31:16
// Commit 64: 2025-02-20T14:17:19
// Commit 100: 2025-03-03T05:19:03
// Commit 27: 2025-02-09T16:12:42
// Commit 46: 2025-02-15T07:32:17
// Commit 50: 2025-02-16T11:00:08
// Commit 59: 2025-02-19T03:27:08
// Commit 70: 2025-02-22T09:00:45
// Commit 108: 2025-03-05T14:09:17
// Commit 135: 2025-03-13T13:30:09
// Commit 139: 2025-03-14T17:43:07
// Commit 141: 2025-03-15T07:23:23
// Commit 146: 2025-03-16T19:11:22
// Commit 197: 2025-03-31T20:08:08
// Commit 200: 2025-04-01T17:02:05
// Commit 33: 2025-02-11T10:59:44
// Commit 38: 2025-02-12T22:56:15
// Commit 131: 2025-03-12T09:00:41
// Commit 140: 2025-03-15T00:29:45
// Commit 143: 2025-03-15T22:18:56
// Commit 172: 2025-03-24T10:52:20
// Commit 193: 2025-03-30T15:42:20
// Commit 21: 2025-02-07T21:46:58
// Commit 50: 2025-02-16T11:17:59
// Commit 56: 2025-02-18T05:51:06
// Commit 168: 2025-03-23T06:43:08
// Commit 176: 2025-03-25T15:33:52
// Commit 198: 2025-04-01T03:23:32
// Commit 64: 2025-02-20T14:04:55
// Commit 95: 2025-03-01T18:08:27
// Commit 118: 2025-03-08T13:20:10
// Commit 175: 2025-03-25T08:46:49
// Commit 177: 2025-03-25T22:06:09
// Commit 1: 2025-02-02T00:44:16
// Commit 14: 2025-02-05T20:34:13
// Commit 22: 2025-02-08T04:56:25
