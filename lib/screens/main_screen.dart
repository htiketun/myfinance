import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import 'dashboard_screen.dart';
import 'transactions_screen.dart';
import 'analytics_screen.dart';
import 'budgets_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TransactionsScreen(),
    AnalyticsScreen(),
    BudgetsScreen(),
    SettingsScreen(),
  ];

  final List<NavigationItem> _navigationItems = const [
    NavigationItem(
      icon: Icons.dashboard,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    NavigationItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      label: 'Transactions',
    ),
    NavigationItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Analytics',
    ),
    NavigationItem(
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet,
      label: 'Budgets',
    ),
    NavigationItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isDark = themeService.isDarkMode;
    
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                : Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          boxShadow: isDark ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ] : null,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark 
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: isDark 
            ? Colors.grey[400]
            : Colors.grey[600],
          selectedFontSize: 12,
          unselectedFontSize: 10,
          elevation: 0,
          items: _navigationItems.map((item) => BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _selectedIndex == _navigationItems.indexOf(item)
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _selectedIndex == _navigationItems.indexOf(item) 
                  ? item.activeIcon 
                  : item.icon,
                size: 24,
              ),
            ),
            label: item.label,
          )).toList(),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}// Commit 12: 2025-02-05T06:46:03
// Commit 73: 2025-02-23T06:38:13
// Commit 81: 2025-02-25T14:39:00
// Commit 122: 2025-03-09T17:38:08
// Commit 130: 2025-03-12T01:41:07
// Commit 2: 2025-02-02T07:29:01
// Commit 16: 2025-02-06T10:44:50
// Commit 50: 2025-02-16T11:00:08
// Commit 61: 2025-02-19T17:05:50
// Commit 93: 2025-03-01T04:01:42
// Commit 103: 2025-03-04T02:53:27
// Commit 142: 2025-03-15T14:54:45
// Commit 147: 2025-03-17T02:30:24
// Commit 160: 2025-03-20T22:10:52
// Commit 164: 2025-03-22T02:28:09
// Commit 188: 2025-03-29T04:03:36
// Commit 19: 2025-02-07T07:58:33
// Commit 22: 2025-02-08T05:40:26
// Commit 35: 2025-02-12T00:55:02
// Commit 107: 2025-03-05T07:04:06
// Commit 136: 2025-03-13T20:15:12
// Commit 151: 2025-03-18T06:13:17
// Commit 159: 2025-03-20T14:44:44
// Commit 166: 2025-03-22T16:49:37
// Commit 185: 2025-03-28T07:09:14
// Commit 197: 2025-03-31T19:41:08
// Commit 25: 2025-02-09T02:11:58
// Commit 31: 2025-02-10T21:01:45
// Commit 45: 2025-02-14T23:37:37
// Commit 50: 2025-02-16T11:17:59
// Commit 69: 2025-02-22T01:54:44
// Commit 90: 2025-02-28T07:04:25
// Commit 114: 2025-03-07T08:38:44
// Commit 133: 2025-03-12T23:12:39
// Commit 138: 2025-03-14T10:35:57
// Commit 149: 2025-03-17T16:38:31
// Commit 155: 2025-03-19T10:54:15
// Commit 165: 2025-03-22T09:45:51
// Commit 166: 2025-03-22T16:14:47
// Commit 182: 2025-03-27T09:45:15
// Commit 190: 2025-03-29T18:42:00
// Commit 198: 2025-04-01T03:23:32
// Commit 6: 2025-02-03T11:25:18
// Commit 17: 2025-02-06T17:44:18
// Commit 42: 2025-02-14T03:13:10
// Commit 45: 2025-02-14T23:33:10
// Commit 52: 2025-02-17T01:52:14
// Commit 61: 2025-02-19T17:35:15
// Commit 85: 2025-02-26T18:56:11
// Commit 100: 2025-03-03T05:54:44
// Commit 119: 2025-03-08T19:56:18
// Commit 124: 2025-03-10T07:12:56
// Commit 139: 2025-03-14T17:37:34
// Commit 166: 2025-03-22T16:24:47
// Commit 167: 2025-03-22T23:37:12
// Commit 171: 2025-03-24T04:20:09
// Commit 174: 2025-03-25T01:16:57
// Commit 176: 2025-03-25T15:16:54
// Commit 181: 2025-03-27T03:13:03
// Commit 189: 2025-03-29T11:03:01
// Commit 190: 2025-03-29T19:00:54
// Commit 197: 2025-03-31T19:55:11
// Commit 8: 2025-02-04T02:24:31
// Commit 12: 2025-02-05T06:41:33
