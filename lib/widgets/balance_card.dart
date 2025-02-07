import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/transaction_service.dart';
import '../services/theme_service.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionService = Provider.of<TransactionService>(context);
    final themeService = Provider.of<ThemeService>(context);
    final isDark = themeService.isDarkMode;

    final balance = transactionService.balance;
    final totalIncome = transactionService.totalIncome;
    final totalExpenses = transactionService.totalExpenses;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                ]
              : [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Balance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white.withOpacity(0.9),
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\K ${balance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildBalanceItem(
                    context,
                    'Income',
                    totalIncome,
                    Icons.trending_up,
                    Colors.green.shade300,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildBalanceItem(
                    context,
                    'Expenses',
                    totalExpenses,
                    Icons.trending_down,
                    Colors.red.shade300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceItem(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '\K ${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
// Commit 85: 2025-02-26T18:44:58
// Commit 93: 2025-03-01T03:26:23
// Commit 71: 2025-02-22T16:22:57
// Commit 96: 2025-03-02T01:16:34
// Commit 112: 2025-03-06T18:49:30
// Commit 113: 2025-03-07T01:54:50
// Commit 179: 2025-03-26T13:08:08
// Commit 14: 2025-02-05T20:23:55
// Commit 19: 2025-02-07T07:58:33
// Commit 79: 2025-02-25T01:08:16
// Commit 100: 2025-03-03T04:59:48
// Commit 3: 2025-02-02T14:24:06
// Commit 18: 2025-02-07T01:12:08
// Commit 23: 2025-02-08T11:46:23
// Commit 40: 2025-02-13T13:02:39
// Commit 51: 2025-02-16T18:46:16
// Commit 52: 2025-02-17T01:47:35
// Commit 188: 2025-03-29T04:24:09
// Commit 28: 2025-02-09T23:52:56
// Commit 53: 2025-02-17T08:42:18
// Commit 101: 2025-03-03T12:32:27
// Commit 142: 2025-03-15T14:38:52
// Commit 157: 2025-03-20T00:43:04
// Commit 163: 2025-03-21T19:33:12
// Commit 178: 2025-03-26T05:47:00
// Commit 192: 2025-03-30T08:55:52
// Commit 194: 2025-03-30T22:51:31
// Commit 19: 2025-02-07T07:58:41
