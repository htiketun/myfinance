import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/demo_data_service.dart';
import '../services/transaction_service.dart';
import '../services/budget_service.dart';
import '../services/category_service.dart';

class DemoDataCard extends StatefulWidget {
  const DemoDataCard({super.key});

  @override
  State<DemoDataCard> createState() => _DemoDataCardState();
}

class _DemoDataCardState extends State<DemoDataCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDemoLoaded = DemoDataService.isDemoDataLoaded;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isDemoLoaded ? Icons.data_usage : Icons.data_saver_on,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDemoLoaded ? 'Demo Data Loaded' : 'Load Demo Data',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isDemoLoaded
                              ? 'Sample data is currently loaded in your app'
                              : 'Load sample transactions and budgets to explore FinanceArcade',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (isDemoLoaded) ...[
                _buildDemoStats(),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  if (isDemoLoaded) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _clearDemoData,
                        icon: _isLoading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              )
                            : Icon(Icons.delete_sweep,
                                color: Theme.of(context).colorScheme.error),
                        label: Text(
                          'Clear Demo Data',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _loadDemoData,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.download, color: Colors.white),
                        label: const Text(
                          'Load Demo Data',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Demo Data Includes:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('88+', 'Transactions', Icons.receipt_long),
              _buildStatColumn('5', 'Budgets', Icons.account_balance_wallet),
              _buildStatColumn('90', 'Days of Data', Icons.calendar_today),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.tertiary,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
      ],
    );
  }

  Future<void> _loadDemoData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await DemoDataService.loadDemoData(
        transactionService: context.read<TransactionService>(),
        budgetService: context.read<BudgetService>(),
        categoryService: context.read<CategoryService>(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Demo data loaded successfully! Explore FinanceArcade features.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
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
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to load demo data: $e',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> _clearDemoData() async {
    // Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange[400], size: 28),
            const SizedBox(width: 12),
            const Text('Clear Demo Data'),
          ],
        ),
        content: const Text(
          'This will remove all demo transactions and budgets. Your categories will remain. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );

    if (confirmed != true || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await DemoDataService.clearDemoData(
        transactionService: context.read<TransactionService>(),
        budgetService: context.read<BudgetService>(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Demo data cleared successfully!',
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
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to clear demo data: $e',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}
// Commit 125: 2025-03-10T14:35:51
// Commit 141: 2025-03-15T07:56:22
// Commit 123: 2025-03-10T00:26:29
// Commit 53: 2025-02-17T08:46:31
// Commit 58: 2025-02-18T20:07:00
// Commit 72: 2025-02-22T23:15:26
// Commit 78: 2025-02-24T17:18:28
// Commit 107: 2025-03-05T07:10:10
// Commit 126: 2025-03-10T21:29:55
// Commit 191: 2025-03-30T02:04:00
// Commit 196: 2025-03-31T13:32:42
// Commit 4: 2025-02-02T21:52:55
// Commit 16: 2025-02-06T11:04:48
// Commit 20: 2025-02-07T15:13:11
// Commit 119: 2025-03-08T20:11:26
// Commit 124: 2025-03-10T07:14:53
// Commit 130: 2025-03-12T01:45:53
// Commit 141: 2025-03-15T07:40:38
// Commit 159: 2025-03-20T14:44:44
// Commit 164: 2025-03-22T02:28:41
// Commit 169: 2025-03-23T14:02:27
// Commit 176: 2025-03-25T15:44:32
// Commit 190: 2025-03-29T18:49:26
// Commit 34: 2025-02-11T18:30:04
// Commit 45: 2025-02-14T23:37:37
// Commit 60: 2025-02-19T10:10:42
// Commit 68: 2025-02-21T18:45:00
// Commit 84: 2025-02-26T12:22:49
// Commit 138: 2025-03-14T10:35:57
// Commit 145: 2025-03-16T11:39:48
// Commit 148: 2025-03-17T09:43:33
// Commit 161: 2025-03-21T05:08:30
// Commit 186: 2025-03-28T14:39:59
// Commit 13: 2025-02-05T13:49:44
// Commit 30: 2025-02-10T13:21:46
// Commit 63: 2025-02-20T07:35:35
// Commit 128: 2025-03-11T11:30:28
// Commit 130: 2025-03-12T02:00:33
// Commit 161: 2025-03-21T05:43:10
// Commit 190: 2025-03-29T19:00:54
// Commit 2: 2025-02-02T07:32:05
// Commit 11: 2025-02-04T23:07:22
// Commit 24: 2025-02-08T19:45:25
// Commit 44: 2025-02-14T16:46:41
