import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/transaction_service.dart';
import '../services/category_service.dart';
import '../models/transaction.dart';

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({super.key});

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    final transactionService = context.read<TransactionService>();
    _searchController.text = transactionService.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionService>(
      builder: (context, transactionService, child) {
        final hasActiveFilters = transactionService.filterCategoryId != null ||
                                transactionService.filterType != null ||
                                transactionService.filterDateRange != null ||
                                transactionService.searchQuery.isNotEmpty;

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
            ),
          ),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search transactions...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          transactionService.setSearchQuery(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: hasActiveFilters 
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        icon: Icon(
                          Icons.tune,
                          color: hasActiveFilters 
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Filter Options
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _isExpanded ? null : 0,
                child: _isExpanded ? _buildFilterOptions() : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOptions() {
    return Consumer2<TransactionService, CategoryService>(
      builder: (context, transactionService, categoryService, child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 8),
              
              // Type Filter
              Text(
                'Transaction Type',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTypeChip('All', null, transactionService),
                  const SizedBox(width: 8),
                  _buildTypeChip('Income', TransactionType.income, transactionService),
                  const SizedBox(width: 8),
                  _buildTypeChip('Expense', TransactionType.expense, transactionService),
                ],
              ),
              const SizedBox(height: 16),
              
              // Category Filter
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip('All', null, transactionService),
                    const SizedBox(width: 8),
                    ...categoryService.categories.map((category) => 
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryChip(
                          category.name, 
                          category.id, 
                          transactionService,
                          color: category.color,
                          icon: category.icon,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Date Range Filter
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDateRange(transactionService),
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        transactionService.filterDateRange != null
                          ? 'Custom Range'
                          : 'Select Date Range',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {
                      transactionService.clearFilters();
                      _searchController.clear();
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeChip(String label, TransactionType? type, TransactionService service) {
    final isSelected = service.filterType == type;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        service.setTypeFilter(selected ? type : null);
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildCategoryChip(
    String label, 
    String? categoryId, 
    TransactionService service, {
    Color? color,
    IconData? icon,
  }) {
    final isSelected = service.filterCategoryId == categoryId;
    
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        service.setCategoryFilter(selected ? categoryId : null);
      },
      selectedColor: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.2),
      checkmarkColor: color ?? Theme.of(context).colorScheme.primary,
    );
  }

  Future<void> _selectDateRange(TransactionService service) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: service.filterDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      service.setDateRangeFilter(picked);
    }
  }
}// Commit 51: 2025-02-16T18:36:01
// Commit 112: 2025-03-06T18:18:25
// Commit 166: 2025-03-22T16:50:32
// Commit 33: 2025-02-11T11:12:02
// Commit 101: 2025-03-03T12:19:11
// Commit 117: 2025-03-08T05:43:03
// Commit 118: 2025-03-08T12:57:56
// Commit 131: 2025-03-12T08:37:49
// Commit 133: 2025-03-12T23:05:44
// Commit 149: 2025-03-17T16:07:15
// Commit 150: 2025-03-17T23:24:10
// Commit 159: 2025-03-20T14:45:18
// Commit 161: 2025-03-21T05:16:22
// Commit 173: 2025-03-24T18:10:58
// Commit 180: 2025-03-26T20:08:25
// Commit 80: 2025-02-25T07:36:49
// Commit 93: 2025-03-01T03:23:04
// Commit 114: 2025-03-07T08:22:41
// Commit 179: 2025-03-26T12:58:50
// Commit 31: 2025-02-10T21:01:45
// Commit 67: 2025-02-21T11:55:23
// Commit 104: 2025-03-04T09:35:35
// Commit 117: 2025-03-08T05:59:39
// Commit 121: 2025-03-09T10:30:16
// Commit 164: 2025-03-22T02:12:06
// Commit 65: 2025-02-20T21:26:35
// Commit 90: 2025-02-28T07:00:25
// Commit 114: 2025-03-07T08:29:57
// Commit 144: 2025-03-16T05:20:09
// Commit 170: 2025-03-23T20:51:14
// Commit 180: 2025-03-26T20:03:31
// Commit 199: 2025-04-01T09:57:49
// Commit 3: 2025-02-02T14:53:29
