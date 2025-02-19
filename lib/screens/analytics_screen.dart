import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/transaction_service.dart';
import '../services/category_service.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../widgets/search_filter_bar.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String _selectedPeriod = 'This Month';
  int _selectedTabIndex = 0;
  late TabController _tabController;

  final List<String> _periods = [
    'This Week',
    'This Month',
    'Last 3 Months',
    'This Year',
    'All Time'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

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
    _tabController.dispose();
    super.dispose();
  }

  DateTime _getStartDate() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case 'This Week':
        return now.subtract(Duration(days: now.weekday - 1));
      case 'This Month':
        return DateTime(now.year, now.month, 1);
      case 'Last 3 Months':
        return DateTime(now.year, now.month - 3, 1);
      case 'This Year':
        return DateTime(now.year, 1, 1);
      default:
        return DateTime(2020, 1, 1); // All time
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Column(
                children: [
                  _buildHeader(),
                  _buildPeriodSelector(),
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewTab(),
                        _buildCategoryTab(),
                        _buildTrendsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.analytics,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analytics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Financial insights & trends',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _periods.length,
        itemBuilder: (context, index) {
          final period = _periods[index];
          final isSelected = _selectedPeriod == period;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriod = period;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8),
                        ],
                      )
                    : null,
                color:
                    isSelected ? null : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(icon: Icon(Icons.dashboard_outlined), text: 'Overview'),
          Tab(icon: Icon(Icons.category_outlined), text: 'Categories'),
          Tab(icon: Icon(Icons.trending_up_outlined), text: 'Trends'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer2<TransactionService, CategoryService>(
      builder: (context, transactionService, categoryService, child) {
        final startDate = _getStartDate();
        final transactions = transactionService.transactions
            .where((t) => t.date.isAfter(startDate))
            .toList();

        final totalIncome = transactions
            .where((t) => t.type == TransactionType.income)
            .fold(0.0, (sum, t) => sum + t.amount);

        final totalExpenses = transactions
            .where((t) => t.type == TransactionType.expense)
            .fold(0.0, (sum, t) => sum + t.amount);

        final balance = totalIncome - totalExpenses;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildBalanceCard(balance, totalIncome, totalExpenses),
              const SizedBox(height: 20),
              _buildIncomeExpenseChart(totalIncome, totalExpenses),
              const SizedBox(height: 20),
              _buildQuickStats(transactions),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(double balance, double income, double expenses) {
    return Card(
      elevation: 12,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              balance >= 0
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              balance >= 0
                  ? Colors.green.withOpacity(0.05)
                  : Colors.red.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (balance >= 0 ? Colors.green : Colors.red)
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      balance >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: balance >= 0 ? Colors.green : Colors.red,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Net Balance',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                        ),
                        Text(
                          '\K ${balance.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: balance >= 0 ? Colors.green : Colors.red,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildBalanceItem(
                      'Income',
                      income,
                      Colors.green,
                      Icons.arrow_upward,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                  Expanded(
                    child: _buildBalanceItem(
                      'Expenses',
                      expenses,
                      Colors.red,
                      Icons.arrow_downward,
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

  Widget _buildBalanceItem(
      String title, double amount, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '\K ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseChart(double income, double expenses) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income vs Expenses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: income + expenses > 0
                  ? PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 50,
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: income,
                            title:
                                '${(income / (income + expenses) * 100).toStringAsFixed(1)}%',
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: expenses,
                            title:
                                '${(expenses / (income + expenses) * 100).toStringAsFixed(1)}%',
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        'No data available',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Income', Colors.green),
                _buildLegendItem('Expenses', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildQuickStats(List<Transaction> transactions) {
    final avgTransaction = transactions.isNotEmpty
        ? transactions.fold(0.0, (sum, t) => sum + t.amount) /
            transactions.length
        : 0.0;

    final maxTransaction = transactions.isNotEmpty
        ? transactions.map((t) => t.amount).reduce((a, b) => a > b ? a : b)
        : 0.0;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                    'Total Transactions',
                    transactions.length.toString(),
                    Icons.receipt_long,
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Average',
                    '\K ${avgTransaction.toStringAsFixed(2)}',
                    Icons.analytics,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Highest',
                    '\K ${maxTransaction.toStringAsFixed(2)}',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Period',
                    _selectedPeriod,
                    Icons.calendar_today,
                    Colors.purple,
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
      String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab() {
    return Consumer2<TransactionService, CategoryService>(
      builder: (context, transactionService, categoryService, child) {
        final startDate = _getStartDate();
        final transactions = transactionService.transactions
            .where((t) => t.date.isAfter(startDate))
            .toList();

        // Group transactions by category
        final categoryMap = <String, double>{};
        for (final transaction in transactions) {
          if (transaction.type == TransactionType.expense) {
            categoryMap[transaction.categoryId] =
                (categoryMap[transaction.categoryId] ?? 0) + transaction.amount;
          }
        }

        final sortedCategories = categoryMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCategoryChart(sortedCategories, categoryService),
              const SizedBox(height: 20),
              _buildCategoryList(sortedCategories, categoryService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChart(List<MapEntry<String, double>> categories,
      CategoryService categoryService) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expenses by Category',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: categories.isNotEmpty
                  ? PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                        sections: categories.take(6).map((entry) {
                          final category = categoryService.categories
                              .firstWhere((c) => c.id == entry.key);
                          final total =
                              categories.fold(0.0, (sum, e) => sum + e.value);
                          final percentage = (entry.value / total) * 100;

                          return PieChartSectionData(
                            color: Color(category.colorValue),
                            value: entry.value,
                            title: '${percentage.toStringAsFixed(1)}%',
                            radius: 70,
                            titleStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : Center(
                      child: Text(
                        'No expense data available',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(List<MapEntry<String, double>> categories,
      CategoryService categoryService) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (categories.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'No category data available',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                  ),
                ),
              )
            else
              ...categories.map((entry) {
                final category = categoryService.categories
                    .firstWhere((c) => c.id == entry.key);
                final total = categories.fold(0.0, (sum, e) => sum + e.value);
                final percentage = (entry.value / total) * 100;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(category.colorValue).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          IconData(category.iconCodePoint,
                              fontFamily: 'MaterialIcons'),
                          color: Color(category.colorValue),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\K ${entry.value.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsTab() {
    return Consumer<TransactionService>(
      builder: (context, transactionService, child) {
        final startDate = _getStartDate();
        final transactions = transactionService.transactions
            .where((t) => t.date.isAfter(startDate))
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTrendChart(transactions),
              const SizedBox(height: 20),
              _buildTrendInsights(transactions),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendChart(List<Transaction> transactions) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending Trends',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: transactions.isNotEmpty
                  ? LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _generateTrendSpots(transactions),
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                              ],
                            ),
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.3),
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        'No trend data available',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateTrendSpots(List<Transaction> transactions) {
    if (transactions.isEmpty) return [];

    // Group transactions by day and calculate daily expenses
    final dailyExpenses = <DateTime, double>{};
    for (final transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        final date = DateTime(transaction.date.year, transaction.date.month,
            transaction.date.day);
        dailyExpenses[date] = (dailyExpenses[date] ?? 0) + transaction.amount;
      }
    }

    final sortedDates = dailyExpenses.keys.toList()..sort();
    final spots = <FlSpot>[];

    for (int i = 0; i < sortedDates.length; i++) {
      spots.add(FlSpot(i.toDouble(), dailyExpenses[sortedDates[i]]!));
    }

    return spots;
  }

  Widget _buildTrendInsights(List<Transaction> transactions) {
    final expenses =
        transactions.where((t) => t.type == TransactionType.expense).toList();

    final avgDaily = expenses.isNotEmpty
        ? expenses.fold(0.0, (sum, t) => sum + t.amount) /
            30 // Rough daily average
        : 0.0;

    final weeklyTrend = _calculateWeeklyTrend(expenses);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trend Insights',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              'Daily Average',
              '\K ${avgDaily.toStringAsFixed(2)}',
              Icons.calendar_today,
              Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              'Weekly Trend',
              weeklyTrend > 0
                  ? '+${weeklyTrend.toStringAsFixed(1)}%'
                  : '${weeklyTrend.toStringAsFixed(1)}%',
              weeklyTrend > 0 ? Icons.trending_up : Icons.trending_down,
              weeklyTrend > 0 ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              'Total Days',
              transactions.map((t) => t.date).toSet().length.toString(),
              Icons.event,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  double _calculateWeeklyTrend(List<Transaction> expenses) {
    if (expenses.length < 14) return 0.0;

    final now = DateTime.now();
    final thisWeek = expenses
        .where((t) => t.date.isAfter(now.subtract(const Duration(days: 7))))
        .fold(0.0, (sum, t) => sum + t.amount);

    final lastWeek = expenses
        .where((t) =>
            t.date.isAfter(now.subtract(const Duration(days: 14))) &&
            t.date.isBefore(now.subtract(const Duration(days: 7))))
        .fold(0.0, (sum, t) => sum + t.amount);

    if (lastWeek == 0) return 0.0;
    return ((thisWeek - lastWeek) / lastWeek) * 100;
  }

  Widget _buildInsightItem(
      String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
      Category category, double amount, double percentage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // ✅ Fixed: Use constant icon directly from category
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category.icon, // This now returns a constant IconData
              color: category.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\K ${amount.toStringAsFixed(2)}  ',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: category.type == CategoryTransactionType.expense
                          ? Colors.red.shade400
                          : Colors.green.shade400,
                    ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: category.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// Commit 39: 2025-02-13T05:26:08
// Commit 41: 2025-02-13T19:40:57
// Commit 42: 2025-02-14T03:14:04
// Commit 153: 2025-03-18T20:55:52
// Commit 177: 2025-03-25T22:40:02
// Commit 34: 2025-02-11T17:55:32
// Commit 104: 2025-03-04T09:49:26
// Commit 12: 2025-02-05T06:46:23
// Commit 41: 2025-02-13T19:25:18
// Commit 90: 2025-02-28T06:47:21
// Commit 136: 2025-03-13T20:06:16
// Commit 140: 2025-03-15T00:10:46
// Commit 153: 2025-03-18T20:40:10
// Commit 20: 2025-02-07T15:13:11
// Commit 21: 2025-02-07T21:54:04
// Commit 28: 2025-02-09T23:52:14
// Commit 65: 2025-02-20T21:10:39
// Commit 74: 2025-02-23T12:57:22
// Commit 85: 2025-02-26T19:04:09
// Commit 87: 2025-02-27T09:12:45
// Commit 99: 2025-03-02T22:37:04
// Commit 108: 2025-03-05T14:28:12
// Commit 113: 2025-03-07T00:59:03
// Commit 123: 2025-03-10T00:14:50
// Commit 200: 2025-04-01T17:28:52
// Commit 43: 2025-02-14T10:19:24
// Commit 83: 2025-02-26T05:15:35
// Commit 108: 2025-03-05T13:57:54
// Commit 123: 2025-03-10T00:37:37
// Commit 1: 2025-02-02T00:54:58
// Commit 23: 2025-02-08T12:26:21
// Commit 96: 2025-03-02T01:31:43
// Commit 102: 2025-03-03T19:57:12
// Commit 108: 2025-03-05T13:42:48
// Commit 113: 2025-03-07T01:55:49
// Commit 116: 2025-03-07T23:06:55
// Commit 123: 2025-03-09T23:50:22
// Commit 186: 2025-03-28T14:40:54
// Commit 29: 2025-02-10T06:35:43
// Commit 33: 2025-02-11T11:21:49
// Commit 48: 2025-02-15T21:39:40
// Commit 50: 2025-02-16T11:47:59
// Commit 57: 2025-02-18T13:03:56
// Commit 61: 2025-02-19T16:55:45
