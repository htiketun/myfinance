import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/budget_service.dart';
import '../services/category_service.dart';
import '../services/transaction_service.dart';
import '../models/budget.dart';
import '../widgets/budget_card.dart';
import '../screens/add_budget_screen.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Budgets',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
            tooltip: 'Filter Budgets',
          ),
        ],
      ),
      body: Consumer3<BudgetService, CategoryService, TransactionService>(
        builder: (context, budgetService, categoryService, transactionService,
            child) {
          // Update budget spending with latest transactions
          WidgetsBinding.instance.addPostFrameCallback((_) {
            budgetService.updateBudgetSpending(transactionService);
          });

          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: _buildBudgetsList(budgetService, categoryService),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: FloatingActionButton.extended(
                onPressed: _addBudget,
                icon: const Icon(Icons.add),
                label: const Text('Add Budget'),
                elevation: 8,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBudgetsList(
      BudgetService budgetService, CategoryService categoryService) {
    final filteredBudgets = _getFilteredBudgets(budgetService.budgets);

    if (filteredBudgets.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        final transactionService = context.read<TransactionService>();
        await budgetService.updateBudgetSpending(transactionService);
      },
      child: Column(
        children: [
          // Summary Card - Arcade style
          if (budgetService.budgets.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.15),
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Budgeted',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          '\K ${_getTotalBudgetAmount(budgetService.budgets).toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Spent',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          '\K ${_getTotalSpentAmount(budgetService.budgets).toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[400],
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Remaining',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          '\K ${_getRemainingBudgetAmount(budgetService.budgets).toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _getRemainingBudgetAmount(
                                                budgetService.budgets) >=
                                            0
                                        ? Colors.green[400]
                                        : Colors.red[400],
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Filter Chips - Arcade style
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Active'),
                _buildFilterChip('Over Budget'),
                _buildFilterChip('On Track'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Budgets List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredBudgets.length,
              itemBuilder: (context, index) {
                final budget = filteredBudgets[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: BudgetCard(
                    budget: budget,
                    onTap: () => _showBudgetOptions(budget),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          filter,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        onSelected: (selected) {
          setState(() {
            _selectedFilter = filter;
          });
        },
        selectedColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        checkmarkColor: Theme.of(context).colorScheme.primary,
        elevation: isSelected ? 4 : 1,
        shadowColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.withValues(alpha: 0.15),
                    Colors.orange.withValues(alpha: 0.08),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 64,
                color: Colors.orange[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Budgets Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first budget to start tracking your spending goals',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _addBudget,
              icon: const Icon(Icons.add),
              label: const Text('Create Budget'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Budget> _getFilteredBudgets(List<Budget> budgets) {
    switch (_selectedFilter) {
      case 'Active':
        return budgets.where((b) => _isBudgetActive(b)).toList();
      case 'Over Budget':
        return budgets
            .where((b) => b.spent > b.amount)
            .toList(); // Use 'spent' instead of 'spentAmount'
      case 'On Track':
        return budgets
            .where((b) => b.spent <= b.amount && _isBudgetActive(b))
            .toList(); // Use 'spent' instead of 'spentAmount'
      default:
        return budgets;
    }
  }

  bool _isBudgetActive(Budget budget) {
    final now = DateTime.now();
    return now.isAfter(budget.startDate) && now.isBefore(budget.endDate);
  }

  // Helper methods for budget calculations
  double _getTotalBudgetAmount(List<Budget> budgets) {
    return budgets.fold(0.0, (sum, budget) => sum + budget.amount);
  }

  double _getTotalSpentAmount(List<Budget> budgets) {
    return budgets.fold(0.0, (sum, budget) => sum + budget.spent);
  }

  double _getRemainingBudgetAmount(List<Budget> budgets) {
    return _getTotalBudgetAmount(budgets) - _getTotalSpentAmount(budgets);
  }

  void _addBudget() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddBudgetScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOutCubic)),
            ),
            child: child,
          );
        },
      ),
    );
  }

  void _editBudget(Budget budget) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddBudgetScreen(budget: budget),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOutCubic)),
            ),
            child: child,
          );
        },
      ),
    );
  }

  void _showBudgetOptions(Budget budget) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Budget'),
                onTap: () {
                  Navigator.pop(context);
                  _editBudget(budget);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red[400]),
                title: Text(
                  'Delete Budget',
                  style: TextStyle(color: Colors.red[400]),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteBudget(budget);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteBudget(Budget budget) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red[400]),
            const SizedBox(width: 8),
            const Text('Delete Budget'),
          ],
        ),
        content: Text('Are you sure you want to delete "${budget.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<BudgetService>().deleteBudget(budget.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Budget deleted successfully'),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(child: Text('Error deleting budget: $e')),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Filter Budgets',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ...['All', 'Active', 'Over Budget', 'On Track'].map((filter) {
                return RadioListTile<String>(
                  value: filter,
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.pop(context);
                  },
                  title: Text(filter),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
// Commit 86: 2025-02-27T01:55:22
// Commit 58: 2025-02-18T19:42:50
// Commit 80: 2025-02-25T07:44:31
// Commit 102: 2025-03-03T19:58:07
// Commit 47: 2025-02-15T13:58:31
// Commit 64: 2025-02-20T14:50:57
// Commit 159: 2025-03-20T14:45:18
// Commit 170: 2025-03-23T20:53:12
// Commit 186: 2025-03-28T14:04:25
// Commit 199: 2025-04-01T10:46:28
// Commit 4: 2025-02-02T21:52:55
// Commit 34: 2025-02-11T18:37:01
// Commit 39: 2025-02-13T05:28:38
// Commit 50: 2025-02-16T11:45:28
// Commit 102: 2025-03-03T19:53:18
// Commit 127: 2025-03-11T05:03:29
// Commit 149: 2025-03-17T16:47:48
// Commit 150: 2025-03-17T23:45:32
// Commit 162: 2025-03-21T12:41:32
// Commit 168: 2025-03-23T06:47:21
// Commit 13: 2025-02-05T13:45:29
// Commit 54: 2025-02-17T15:53:21
// Commit 60: 2025-02-19T10:10:42
// Commit 70: 2025-02-22T09:02:27
// Commit 111: 2025-03-06T11:10:29
// Commit 115: 2025-03-07T15:22:03
// Commit 121: 2025-03-09T10:30:16
// Commit 154: 2025-03-19T03:25:45
// Commit 178: 2025-03-26T05:18:11
// Commit 200: 2025-04-01T17:40:47
// Commit 8: 2025-02-04T01:58:59
// Commit 11: 2025-02-04T23:35:52
// Commit 12: 2025-02-05T06:12:37
// Commit 37: 2025-02-12T14:55:58
// Commit 39: 2025-02-13T05:20:58
// Commit 55: 2025-02-17T22:21:42
// Commit 58: 2025-02-18T20:33:30
// Commit 63: 2025-02-20T07:35:35
// Commit 67: 2025-02-21T11:56:13
// Commit 93: 2025-03-01T04:01:46
// Commit 103: 2025-03-04T02:15:11
// Commit 109: 2025-03-05T20:57:23
// Commit 126: 2025-03-10T21:30:47
// Commit 152: 2025-03-18T13:42:14
// Commit 155: 2025-03-19T10:32:11
// Commit 172: 2025-03-24T10:41:17
// Commit 194: 2025-03-30T22:51:31
// Commit 198: 2025-04-01T03:23:27
// Commit 17: 2025-02-06T18:06:43
// Commit 39: 2025-02-13T05:11:03
// Commit 40: 2025-02-13T12:31:38
// Commit 42: 2025-02-14T02:58:43
// Commit 56: 2025-02-18T06:21:56
// Commit 73: 2025-02-23T06:11:00
// Commit 78: 2025-02-24T17:56:32
// Commit 113: 2025-03-07T01:27:33
// Commit 140: 2025-03-15T00:29:22
