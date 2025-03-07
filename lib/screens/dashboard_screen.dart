import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/transaction_service.dart';
import '../services/category_service.dart';
import '../services/budget_service.dart';
import '../services/theme_service.dart';
import '../services/demo_data_service.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_stats_card.dart';
import '../widgets/recent_transactions_card.dart';
import '../widgets/budget_progress_card.dart';
import '../widgets/expense_chart_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;
  bool _showDemoPrompt = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for each card
    _animations = List.generate(5, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.5 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _animationController.forward();
    _checkForDemoPrompt();
  }

  void _checkForDemoPrompt() {
    // Check if user has no transactions and demo data is not loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionService = context.read<TransactionService>();
      final hasTransactions = transactionService.transactions.isNotEmpty;
      final hasDemoData = DemoDataService.isDemoDataLoaded;

      if (!hasTransactions && !hasDemoData) {
        setState(() {
          _showDemoPrompt = true;
        });
      }
    });
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
        title: Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'My Finance',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          Consumer<ThemeService>(
            builder: (context, themeService, child) {
              return IconButton(
                icon: Icon(
                  themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => themeService.toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Demo prompt card
              if (_showDemoPrompt) ...[
                _buildDemoPromptCard(),
                const SizedBox(height: 16),
              ],

              // Balance Card
              _buildAnimatedCard(
                index: 0,
                child: const BalanceCard(),
              ),
              const SizedBox(height: 16),

              // Quick Stats Row
              _buildAnimatedCard(
                index: 1,
                child: const QuickStatsCard(),
              ),
              const SizedBox(height: 16),

              // Recent Transactions
              _buildAnimatedCard(
                index: 2,
                child: const RecentTransactionsCard(),
              ),
              const SizedBox(height: 16),

              // Budget Progress
              _buildAnimatedCard(
                index: 3,
                child: const BudgetProgressCard(),
              ),
              const SizedBox(height: 16),

              // Expense Chart
              _buildAnimatedCard(
                index: 4,
                child: const ExpenseChartCard(),
              ),

              const SizedBox(height: 80), // Bottom padding for FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoPromptCard() {
    return Card(
      elevation: 8,
      shadowColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
              Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Welcome to FinanceArcade!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _showDemoPrompt = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Get started by loading sample data to explore all features, or add your first transaction manually.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _loadDemoData,
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text(
                        'Load Demo Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _showDemoPrompt = false;
                      });
                    },
                    child: const Text('Skip'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadDemoData() async {
    try {
      await DemoDataService.loadDemoData(
        transactionService: context.read<TransactionService>(),
        budgetService: context.read<BudgetService>(),
        categoryService: context.read<CategoryService>(),
      );

      setState(() {
        _showDemoPrompt = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Demo data loaded! Explore FinanceArcade features.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load demo data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildAnimatedCard({required int index, required Widget child}) {
    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _animations[index].value)),
          child: Opacity(
            opacity: _animations[index].value,
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _refreshData() async {
    // Refresh all services data
    final transactionService = context.read<TransactionService>();
    final budgetService = context.read<BudgetService>();

    // Update budget spending with latest transactions
    await budgetService.updateBudgetSpending(transactionService);

    // Add a small delay for smooth UX
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
// Commit 9: 2025-02-04T08:39:36
// Commit 37: 2025-02-12T15:01:19
// Commit 117: 2025-03-08T06:15:42
// Commit 7: 2025-02-03T18:57:33
// Commit 18: 2025-02-07T00:53:57
// Commit 28: 2025-02-09T23:51:03
// Commit 38: 2025-02-12T22:22:18
// Commit 173: 2025-03-24T18:04:06
// Commit 186: 2025-03-28T14:32:43
// Commit 190: 2025-03-29T18:45:07
// Commit 39: 2025-02-13T05:42:56
// Commit 46: 2025-02-15T07:32:17
// Commit 71: 2025-02-22T16:22:57
// Commit 79: 2025-02-25T01:10:33
// Commit 131: 2025-03-12T08:37:49
// Commit 132: 2025-03-12T15:32:53
// Commit 138: 2025-03-14T10:38:16
// Commit 150: 2025-03-17T23:24:10
// Commit 165: 2025-03-22T09:32:17
// Commit 171: 2025-03-24T04:14:07
// Commit 173: 2025-03-24T18:10:58
// Commit 177: 2025-03-25T22:49:11
// Commit 8: 2025-02-04T01:53:48
// Commit 43: 2025-02-14T09:34:18
// Commit 49: 2025-02-16T04:22:16
// Commit 76: 2025-02-24T03:43:04
// Commit 94: 2025-03-01T10:43:02
// Commit 98: 2025-03-02T15:33:04
// Commit 112: 2025-03-06T18:00:12
// Commit 144: 2025-03-16T04:31:40
// Commit 165: 2025-03-22T10:03:33
// Commit 175: 2025-03-25T08:39:08
// Commit 187: 2025-03-28T21:47:18
// Commit 198: 2025-04-01T02:57:44
// Commit 32: 2025-02-11T03:29:16
// Commit 59: 2025-02-19T02:43:20
// Commit 96: 2025-03-02T00:58:24
// Commit 112: 2025-03-06T18:26:03
// Commit 113: 2025-03-07T01:35:14
// Commit 116: 2025-03-07T23:05:15
// Commit 152: 2025-03-18T13:24:51
// Commit 162: 2025-03-21T12:40:24
// Commit 171: 2025-03-24T04:30:03
// Commit 184: 2025-03-28T00:20:05
// Commit 25: 2025-02-09T02:50:10
// Commit 40: 2025-02-13T12:14:52
// Commit 57: 2025-02-18T13:20:31
// Commit 73: 2025-02-23T06:24:19
// Commit 78: 2025-02-24T17:16:35
// Commit 81: 2025-02-25T15:02:42
// Commit 86: 2025-02-27T02:46:27
// Commit 89: 2025-02-27T23:53:41
// Commit 106: 2025-03-05T00:12:34
// Commit 112: 2025-03-06T18:07:37
// Commit 132: 2025-03-12T16:04:20
// Commit 136: 2025-03-13T20:06:37
// Commit 138: 2025-03-14T10:43:31
// Commit 148: 2025-03-17T08:56:06
// Commit 163: 2025-03-21T19:33:12
// Commit 3: 2025-02-02T14:53:29
// Commit 25: 2025-02-09T02:46:28
// Commit 62: 2025-02-20T00:46:00
// Commit 72: 2025-02-22T23:13:34
// Commit 114: 2025-03-07T08:44:50
