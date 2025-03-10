import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/storage_service.dart';
import '../services/transaction_service.dart';
import '../services/category_service.dart';
import '../services/budget_service.dart';
import '../widgets/pin_settings_card.dart';
import '../widgets/demo_data_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String _selectedCurrency = 'MMK';
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkMode = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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

    _loadSettings();
    _animationController.forward();
  }

  void _loadSettings() {
    final themeService = context.read<ThemeService>();
    final settings = StorageService.settings;
    setState(() {
      _darkMode = themeService.isDarkMode;
      _selectedCurrency = settings.get('currency', defaultValue: 'MMK');
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
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAbout,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: _buildSettingsList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Demo Data Section - NEW
        _buildSectionHeader('Demo Data'),
        const DemoDataCard(),

        const SizedBox(height: 24),

        // Appearance Section
        _buildSectionHeader('Appearance'),
        _buildSettingsCard([
          Consumer<ThemeService>(
            builder: (context, themeService, child) {
              return SwitchListTile(
                value: themeService.isDarkMode,
                onChanged: (value) {
                  themeService.toggleTheme();
                  setState(() {
                    _darkMode = value;
                  });
                },
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark theme throughout the app'),
                secondary: Icon(
                  themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Currency'),
            subtitle: Text(_selectedCurrency),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showCurrencyPicker,
          ),
        ]),

        const SizedBox(height: 24),

        // Security Section
        _buildSectionHeader('Security & Privacy'),
        _buildSettingsCard([
          SwitchListTile(
            value: _biometricEnabled,
            onChanged: (value) {
              setState(() {
                _biometricEnabled = value;
              });
              _showFeatureComingSoon();
            },
            title: const Text('Biometric Authentication'),
            subtitle: const Text('Use fingerprint or face unlock'),
            secondary: const Icon(Icons.fingerprint),
          ),
          const Divider(height: 1),
          const PinSettingsCard(),
        ]),

        const SizedBox(height: 24),

        // Notifications Section
        _buildSectionHeader('Notifications'),
        _buildSettingsCard([
          SwitchListTile(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _showFeatureComingSoon();
            },
            title: const Text('Push Notifications'),
            subtitle: const Text('Get alerts for budgets and reminders'),
            secondary: const Icon(Icons.notifications_outlined),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Reminder Settings'),
            subtitle: const Text('Configure transaction reminders'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFeatureComingSoon(),
          ),
        ]),

        const SizedBox(height: 24),

        // Data Section
        _buildSectionHeader('Data Management'),
        _buildSettingsCard([
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Backup Data'),
            subtitle: const Text('Export your financial data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showBackupDialog,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.restore_outlined),
            title: const Text('Import Data'),
            subtitle: const Text('Import from backup file'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFeatureComingSoon(),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red.shade400),
            title: Text(
              'Clear All Data',
              style: TextStyle(color: Colors.red.shade400),
            ),
            subtitle: const Text('Permanently delete all your data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showClearDataDialog,
          ),
        ]),

        const SizedBox(height: 24),

        // Support Section
        _buildSectionHeader('Support'),
        _buildSettingsCard([
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & FAQ'),
            subtitle: const Text('Get help with using the app'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showHelpDialog,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('Send Feedback'),
            subtitle: const Text('Help us improve the app'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFeatureComingSoon(),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: const Text('Rate App'),
            subtitle: const Text('Rate us on the app store'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFeatureComingSoon(),
          ),
        ]),

        const SizedBox(height: 24),

        // About Section
        _buildSectionHeader('About'),
        _buildSettingsCard([
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFeatureComingSoon(),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFeatureComingSoon(),
          ),
        ]),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: children,
      ),
    );
  }

  void _showCurrencyPicker() {
    final currencies = [
      {'code': 'MMK', 'name': 'Myanmar Kyat', 'symbol': 'K'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Currency',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showManualCurrencyDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Custom'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  return ListTile(
                    leading: Text(
                      currency['symbol']!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    title: Text(currency['name']!),
                    subtitle: Text(currency['code']!),
                    trailing: _selectedCurrency == currency['code']
                        ? Icon(Icons.check,
                            color: Theme.of(context).colorScheme.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCurrency = currency['code']!;
                      });
                      _saveCurrency(currency['code']!);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Currency changed to ${currency['name']}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showManualCurrencyDialog() {
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final symbolController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Currency'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Currency Code',
                  hintText: 'e.g., MMK, EUR, GBP',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
                maxLength: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Currency Name',
                  hintText: 'e.g., US Dollar',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: symbolController,
                decoration: const InputDecoration(
                  labelText: 'Currency Symbol',
                  hintText: 'e.g., \K , €, £',
                  border: OutlineInputBorder(),
                ),
                maxLength: 5,
              ),
              const SizedBox(height: 8),
              Text(
                'Preview: ${symbolController.text.isEmpty ? '?' : symbolController.text}100.00',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (codeController.text.trim().isEmpty ||
                  nameController.text.trim().isEmpty ||
                  symbolController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              final newCurrency = codeController.text.trim().toUpperCase();
              setState(() {
                _selectedCurrency = newCurrency;
              });
              _saveCurrency(newCurrency);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Currency changed to ${nameController.text.trim()}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Add Currency'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Data'),
        content: const Text(
          'This will create a backup file with all your transactions, categories, and budgets. You can use this file to restore your data later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _createBackup();
            },
            child: const Text('Create Backup'),
          ),
        ],
      ),
    );
  }

  void _createBackup() {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Creating backup...'),
          ],
        ),
      ),
    );

    // Simulate backup creation
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup created successfully! (Feature coming soon)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your transactions, categories, and budgets. This action cannot be undone.\n\nAre you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllData();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All Data'),
          ),
        ],
      ),
    );
  }

  void _clearAllData() {
    // Clear all data from services
    context.read<TransactionService>().clearAllTransactions();
    context.read<CategoryService>().resetToDefaults();
    context.read<BudgetService>().clearAllBudgets();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All data cleared successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & FAQ'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Getting Started',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. Load demo data to explore features'),
              Text('2. Add your income and expense transactions'),
              Text('3. Create budgets to track your spending goals'),
              Text('4. Use analytics to understand your patterns'),
              SizedBox(height: 16),
              Text(
                'Features',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Dashboard with balance overview'),
              Text('• Transaction management'),
              Text('• Budget tracking with alerts'),
              Text('• Analytics and charts'),
              Text('• Search and filter options'),
              Text('• Demo data for exploration'),
              SizedBox(height: 16),
              Text(
                'Tips',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Start with demo data to learn the app'),
              Text('• Regular tracking leads to better insights'),
              Text('• Set realistic budgets based on history'),
              Text('• Use categories to organize expenses'),
              Text('• Check analytics weekly for trends'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About My Finance'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'My Finance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Version 1.0.0'),
              SizedBox(height: 16),
              Text(
                'A comprehensive finance management app with an arcade-style dark theme UI. Track your income, expenses, budgets, and get insights into your financial patterns.',
              ),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Personal finance tracking'),
              Text('• Budget management'),
              Text('• Advanced analytics'),
              Text('• Multi-currency support'),
              Text('• Offline-first with local storage'),
              Text('• Dark/Light theme toggle'),
              Text('• PIN security protection'),
              Text('• Demo data for exploration'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFeatureComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveCurrency(String currency) {
    final settings = StorageService.settings;
    settings.put('currency', currency);
  }
}
// Commit 29: 2025-02-10T06:35:16
// Commit 134: 2025-03-13T06:26:53
// Commit 135: 2025-03-13T13:11:43
// Commit 107: 2025-03-05T07:04:06
// Commit 182: 2025-03-27T10:26:47
// Commit 184: 2025-03-27T23:51:36
// Commit 4: 2025-02-02T21:52:12
// Commit 10: 2025-02-04T16:06:39
// Commit 63: 2025-02-20T07:21:05
// Commit 76: 2025-02-24T03:06:24
// Commit 133: 2025-03-12T23:05:44
// Commit 148: 2025-03-17T09:18:21
// Commit 169: 2025-03-23T14:18:29
// Commit 172: 2025-03-24T11:34:37
// Commit 175: 2025-03-25T08:43:38
// Commit 179: 2025-03-26T13:08:08
// Commit 184: 2025-03-28T00:15:52
// Commit 190: 2025-03-29T18:08:19
// Commit 2: 2025-02-02T07:39:51
// Commit 29: 2025-02-10T06:45:53
// Commit 31: 2025-02-10T20:30:21
// Commit 84: 2025-02-26T11:50:53
// Commit 96: 2025-03-02T00:41:46
// Commit 134: 2025-03-13T05:44:28
// Commit 156: 2025-03-19T18:21:03
// Commit 172: 2025-03-24T10:52:20
// Commit 191: 2025-03-30T02:10:08
// Commit 196: 2025-03-31T13:31:06
// Commit 33: 2025-02-11T10:52:35
// Commit 40: 2025-02-13T13:02:39
// Commit 47: 2025-02-15T14:07:46
// Commit 52: 2025-02-17T01:47:35
// Commit 61: 2025-02-19T17:45:55
// Commit 64: 2025-02-20T14:10:04
// Commit 74: 2025-02-23T13:10:40
// Commit 76: 2025-02-24T03:19:50
// Commit 78: 2025-02-24T17:58:14
// Commit 105: 2025-03-04T16:33:59
// Commit 120: 2025-03-09T02:54:36
// Commit 122: 2025-03-09T17:40:18
// Commit 124: 2025-03-10T07:28:58
// Commit 134: 2025-03-13T05:56:18
// Commit 137: 2025-03-14T03:20:11
// Commit 139: 2025-03-14T17:10:27
// Commit 175: 2025-03-25T08:53:26
// Commit 189: 2025-03-29T11:49:35
// Commit 196: 2025-03-31T12:56:07
// Commit 14: 2025-02-05T20:34:13
// Commit 31: 2025-02-10T21:15:01
// Commit 76: 2025-02-24T03:46:59
// Commit 82: 2025-02-25T22:05:47
// Commit 145: 2025-03-16T12:01:07
// Commit 146: 2025-03-16T18:49:28
// Commit 183: 2025-03-27T16:54:31
// Commit 185: 2025-03-28T07:00:15
// Commit 30: 2025-02-10T13:21:35
// Commit 49: 2025-02-16T04:22:04
// Commit 71: 2025-02-22T16:26:35
// Commit 77: 2025-02-24T10:51:41
// Commit 91: 2025-02-28T13:28:52
// Commit 92: 2025-02-28T20:54:52
// Commit 101: 2025-03-03T12:38:52
// Commit 124: 2025-03-10T07:13:03
