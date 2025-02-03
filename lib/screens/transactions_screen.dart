import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/transaction_service.dart';
import '../services/category_service.dart';
import '../models/transaction.dart';
import '../widgets/transaction_item.dart';
import '../widgets/search_filter_bar.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fabAnimationController;
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scrollController.addListener(_onScroll);
    _animationController.forward();
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_showFab) {
        setState(() => _showFab = false);
        _fabAnimationController.reverse();
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_showFab) {
        setState(() => _showFab = true);
        _fabAnimationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              // Navigate to analytics
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'export':
                  _showExportDialog();
                  break;
                case 'clear_filters':
                  context.read<TransactionService>().clearFilters();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_filters',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Clear Filters'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          const SearchFilterBar(),
          
          // Transactions List
          Expanded(
            child: Consumer<TransactionService>(
              builder: (context, transactionService, child) {
                final transactions = transactionService.transactions;
                
                if (transactions.isEmpty) {
                  return _buildEmptyState();
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _animationController.reset();
                      _animationController.forward();
                    });
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          final animation = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              (index * 0.1).clamp(0.0, 1.0),
                              ((index * 0.1) + 0.5).clamp(0.0, 1.0),
                              curve: Curves.easeOutBack,
                            ),
                          ));
                          
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - animation.value)),
                            child: Opacity(
                              opacity: animation.value,
                              child: TransactionItem(
                                transaction: transaction,
                                onTap: () => _editTransaction(transaction),
                                onLongPress: () => _showTransactionOptions(transaction),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimationController,
        child: FloatingActionButton.extended(
          onPressed: _addTransaction,
          icon: const Icon(Icons.add),
          label: const Text('Add Transaction'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No transactions yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your finances by adding your first transaction',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _addTransaction,
            icon: const Icon(Icons.add),
            label: const Text('Add Transaction'),
          ),
        ],
      ),
    );
  }

  void _addTransaction() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
  }

  void _editTransaction(Transaction transaction) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(transaction: transaction),
      ),
    );
  }

  void _showTransactionOptions(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Transaction'),
              onTap: () {
                Navigator.pop(context);
                _editTransaction(transaction);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Duplicate Transaction'),
              onTap: () {
                Navigator.pop(context);
                _duplicateTransaction(transaction);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red.shade400),
              title: Text(
                'Delete Transaction',
                style: TextStyle(color: Colors.red.shade400),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteTransaction(transaction);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _duplicateTransaction(Transaction transaction) {
    final duplicatedTransaction = transaction.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
    );
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(transaction: duplicatedTransaction),
      ),
    );
  }

  void _confirmDeleteTransaction(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text(
          'Are you sure you want to delete "${transaction.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TransactionService>().deleteTransaction(transaction.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'Export functionality will be available in a future update. This will allow you to export your transactions to CSV or PDF format.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}// Commit 58: 2025-02-18T19:40:04
// Commit 173: 2025-03-24T18:14:36
// Commit 174: 2025-03-25T01:35:28
// Commit 20: 2025-02-07T14:34:22
// Commit 69: 2025-02-22T02:10:36
// Commit 110: 2025-03-06T04:17:38
// Commit 24: 2025-02-08T19:50:15
// Commit 77: 2025-02-24T10:22:07
// Commit 91: 2025-02-28T13:34:03
// Commit 104: 2025-03-04T10:05:22
// Commit 111: 2025-03-06T11:25:58
// Commit 117: 2025-03-08T05:43:03
// Commit 121: 2025-03-09T09:56:12
// Commit 127: 2025-03-11T04:07:55
// Commit 129: 2025-03-11T19:01:53
// Commit 130: 2025-03-12T01:23:23
// Commit 141: 2025-03-15T07:23:23
// Commit 143: 2025-03-15T21:25:05
// Commit 161: 2025-03-21T05:16:22
// Commit 180: 2025-03-26T20:08:25
// Commit 198: 2025-04-01T03:44:57
// Commit 14: 2025-02-05T20:23:55
// Commit 24: 2025-02-08T19:06:21
// Commit 27: 2025-02-09T16:29:34
// Commit 53: 2025-02-17T08:13:40
// Commit 64: 2025-02-20T14:43:16
// Commit 75: 2025-02-23T20:49:30
// Commit 104: 2025-03-04T09:54:04
// Commit 119: 2025-03-08T20:11:26
// Commit 126: 2025-03-10T21:52:20
// Commit 189: 2025-03-29T11:04:54
// Commit 2: 2025-02-02T07:39:07
// Commit 9: 2025-02-04T09:01:44
// Commit 21: 2025-02-07T21:46:58
// Commit 24: 2025-02-08T19:31:30
// Commit 36: 2025-02-12T08:12:27
// Commit 38: 2025-02-12T22:06:01
// Commit 75: 2025-02-23T20:26:46
// Commit 91: 2025-02-28T13:28:53
// Commit 125: 2025-03-10T14:18:47
// Commit 144: 2025-03-16T04:33:46
// Commit 150: 2025-03-17T23:26:40
// Commit 191: 2025-03-30T01:17:01
// Commit 194: 2025-03-30T22:51:25
// Commit 15: 2025-02-06T03:59:27
// Commit 34: 2025-02-11T18:23:40
// Commit 43: 2025-02-14T10:12:52
// Commit 51: 2025-02-16T18:14:52
// Commit 83: 2025-02-26T04:49:57
// Commit 111: 2025-03-06T11:46:14
// Commit 140: 2025-03-15T00:27:29
// Commit 160: 2025-03-20T22:40:17
// Commit 182: 2025-03-27T09:29:07
// Commit 187: 2025-03-28T21:05:24
// Commit 7: 2025-02-03T19:08:13
