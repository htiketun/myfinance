import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/budget.dart';
import '../services/category_service.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final VoidCallback? onTap;

  const BudgetCard({
    super.key,
    required this.budget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryService>(
      builder: (context, categoryService, child) {
        final category = categoryService.getCategoryById(budget.categoryId);
        final progress = budget.amount > 0
            ? (budget.spent / budget.amount).clamp(0.0, 1.0)
            : 0.0;
        final isOverBudget = budget.spent > budget.amount;
        final remaining = budget.amount - budget.spent;

        // Arcade-style color progression with proper MaterialColor handling
        MaterialColor progressColor = Colors.green;
        Color statusTextColor = Colors.green.shade700;
        Color borderColor = Colors.green.shade300;

        if (progress > 0.8) {
          progressColor = Colors.orange;
          statusTextColor = Colors.orange.shade700;
          borderColor = Colors.orange.shade300;
        }
        if (isOverBudget) {
          progressColor = Colors.red;
          statusTextColor = Colors.red.shade700;
          borderColor = Colors.red.shade300;
        }

        return Card(
          elevation: 8,
          shadowColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    progressColor.withValues(alpha: 0.1),
                    progressColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: progressColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with category info - FinanceArcade style
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                category?.color ?? Colors.grey,
                                (category?.color ?? Colors.grey)
                                    .withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (category?.color ?? Colors.grey)
                                    .withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                budget.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                category?.name ?? 'Unknown Category',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Status Badge - FinanceArcade arcade style
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isOverBudget
                                  ? [
                                      Colors.red.withValues(alpha: 0.2),
                                      Colors.red.withValues(alpha: 0.1),
                                    ]
                                  : [
                                      progressColor.withValues(alpha: 0.2),
                                      progressColor.withValues(alpha: 0.1),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isOverBudget
                                  ? Colors.red.shade300
                                  : borderColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            isOverBudget ? 'Over Budget' : 'On Track',
                            style: TextStyle(
                              color: isOverBudget
                                  ? Colors.red.shade700
                                  : statusTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Progress Section - FinanceArcade style with neon glow
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: progressColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: progressColor.withValues(alpha: 0.3),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: progressColor.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                '${(progress * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getDarkerColor(progressColor),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // FinanceArcade-style progress bar with arcade glow effect
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Stack(
                              children: [
                                LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      progressColor),
                                ),
                                // Arcade glow effect overlay
                                if (progress > 0)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: progressColor.withValues(
                                                alpha: 0.3),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Amount Information - FinanceArcade card style
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.surface,
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildAmountInfo(
                            context,
                            'Spent',
                            budget.spent,
                            Colors.red.shade400,
                            Icons.trending_up,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.3),
                          ),
                          _buildAmountInfo(
                            context,
                            'Budget',
                            budget.amount,
                            Theme.of(context).colorScheme.primary,
                            Icons.account_balance_wallet,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.3),
                          ),
                          _buildAmountInfo(
                            context,
                            'Remaining',
                            remaining,
                            remaining >= 0
                                ? Colors.green.shade400
                                : Colors.red.shade400,
                            remaining >= 0 ? Icons.savings : Icons.warning,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Period Information - FinanceArcade arcade style
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${_formatDate(budget.startDate)} - ${_formatDate(budget.endDate)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmountInfo(
    BuildContext context,
    String label,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '\K ${amount.abs().toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  // Helper method to get darker shade of color without using .shade notation
  Color _getDarkerColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}
// Commit 196: 2025-03-31T12:37:01
// Commit 79: 2025-02-25T00:40:14
// Commit 99: 2025-03-02T22:50:18
// Commit 147: 2025-03-17T02:33:28
// Commit 32: 2025-02-11T03:48:59
// Commit 81: 2025-02-25T14:52:34
// Commit 84: 2025-02-26T11:42:21
// Commit 125: 2025-03-10T14:45:57
// Commit 55: 2025-02-17T22:58:57
// Commit 87: 2025-02-27T09:12:45
// Commit 101: 2025-03-03T12:45:29
// Commit 109: 2025-03-05T21:01:00
// Commit 153: 2025-03-18T20:27:26
// Commit 154: 2025-03-19T04:10:35
// Commit 185: 2025-03-28T07:09:14
// Commit 192: 2025-03-30T08:24:42
// Commit 20: 2025-02-07T14:51:25
// Commit 63: 2025-02-20T07:22:18
// Commit 70: 2025-02-22T09:02:27
// Commit 83: 2025-02-26T05:15:35
// Commit 96: 2025-03-02T00:58:24
// Commit 127: 2025-03-11T04:27:12
// Commit 129: 2025-03-11T18:29:32
// Commit 180: 2025-03-26T20:03:05
// Commit 9: 2025-02-04T09:32:43
// Commit 41: 2025-02-13T20:06:22
// Commit 47: 2025-02-15T14:13:46
// Commit 55: 2025-02-17T22:21:42
// Commit 98: 2025-03-02T15:00:27
// Commit 160: 2025-03-20T22:40:17
