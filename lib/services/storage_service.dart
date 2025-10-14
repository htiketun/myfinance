import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../models/category.dart' as finance;
import '../models/budget.dart';
import '../models/financial_goal.dart';

/// FinanceArcade Storage Service - Offline-first Hive database management
/// Handles all local data persistence with arcade-style architecture
class StorageService extends ChangeNotifier {
  static const String transactionsBox = 'financearcade_transactions';
  static const String categoriesBox = 'financearcade_categories';
  static const String budgetsBox = 'financearcade_budgets';
  static const String goalsBox = 'financearcade_goals';
  static const String settingsBox = 'financearcade_settings';

  static bool _initialized = false;
  static bool _adaptersRegistered = false;
  static final Set<int> _registeredAdapters = <int>{};

  /// Initialize FinanceArcade storage with enhanced protection for hot reload
  static Future<void> init() async {
    if (_initialized) {
      debugPrint(
          'FinanceArcade: Storage already initialized, verifying state...');
      await _verifyInitialization();
      return;
    }

    try {
      debugPrint('FinanceArcade: Starting storage initialization...');

      // Register adapters with comprehensive duplicate protection
      await _safeRegisterAdapters();

      // Open FinanceArcade data boxes with safety checks
      await _safeOpenBoxes();

      _initialized = true;
      debugPrint(
          'FinanceArcade: Storage initialization completed successfully');

      // Initialize arcade-style default categories after boxes are ready
      await _initializeDefaultCategories();
    } catch (e, stackTrace) {
      debugPrint('FinanceArcade: Storage initialization error: $e');
      debugPrint('FinanceArcade: Stack trace: $stackTrace');
      _initialized = false;
      rethrow;
    }
  }

  /// Verify that storage is properly initialized
  static Future<void> _verifyInitialization() async {
    try {
      final boxNames = [
        transactionsBox,
        categoriesBox,
        budgetsBox,
        goalsBox,
        settingsBox
      ];

      for (final boxName in boxNames) {
        if (!Hive.isBoxOpen(boxName)) {
          debugPrint('FinanceArcade: Box $boxName not open, reopening...');
          await _reopenBox(boxName);
        }
      }

      debugPrint('FinanceArcade: Storage verification completed');
    } catch (e) {
      debugPrint('FinanceArcade: Error during verification: $e');
      _initialized = false;
      rethrow;
    }
  }

  /// Reopen a specific box based on its name
  static Future<void> _reopenBox(String boxName) async {
    switch (boxName) {
      case transactionsBox:
        await Hive.openBox<Transaction>(boxName);
        break;
      case categoriesBox:
        await Hive.openBox<finance.Category>(boxName);
        break;
      case budgetsBox:
        await Hive.openBox<Budget>(boxName);
        break;
      case goalsBox:
        await Hive.openBox<FinancialGoal>(boxName);
        break;
      case settingsBox:
        await Hive.openBox(boxName);
        break;
    }
  }

  /// Register all Hive adapters with enhanced duplicate protection for FinanceArcade
  static Future<void> _safeRegisterAdapters() async {
    if (_adaptersRegistered) {
      debugPrint('FinanceArcade: Adapters already registered, skipping...');
      return;
    }

    try {
      // FinanceArcade adapter configuration with error recovery
      final adapterConfigs = [
        {
          'id': 0,
          'name': 'TransactionAdapter',
          'factory': () => TransactionAdapter()
        },
        {
          'id': 1,
          'name': 'TransactionTypeAdapter',
          'factory': () => TransactionTypeAdapter()
        },
        {
          'id': 2,
          'name': 'RecurringTypeAdapter',
          'factory': () => RecurringTypeAdapter()
        },
        {
          'id': 3,
          'name': 'CategoryAdapter',
          'factory': () => finance.CategoryAdapter()
        },
        {
          'id': 4,
          'name': 'CategoryTransactionTypeAdapter',
          'factory': () => finance.CategoryTransactionTypeAdapter()
        },
        {'id': 5, 'name': 'BudgetAdapter', 'factory': () => BudgetAdapter()},
        {
          'id': 6,
          'name': 'BudgetPeriodAdapter',
          'factory': () => BudgetPeriodAdapter()
        },
        {
          'id': 7,
          'name': 'FinancialGoalAdapter',
          'factory': () => FinancialGoalAdapter()
        },
        {
          'id': 8,
          'name': 'GoalTypeAdapter',
          'factory': () => GoalTypeAdapter()
        },
      ];

      for (final config in adapterConfigs) {
        final typeId = config['id'] as int;
        final name = config['name'] as String;

        try {
          // Check if we've already registered this adapter in this session
          if (_registeredAdapters.contains(typeId)) {
            debugPrint(
                'FinanceArcade: $name (typeId: $typeId) already registered in session');
            continue;
          }

          // Double-check with Hive's internal registry
          if (!Hive.isAdapterRegistered(typeId)) {
            final adapter = (config['factory'] as Function)();

            // Register with explicit type to avoid dynamic type issues
            switch (typeId) {
              case 0:
                Hive.registerAdapter<Transaction>(
                    adapter as TransactionAdapter);
                break;
              case 1:
                Hive.registerAdapter<TransactionType>(
                    adapter as TransactionTypeAdapter);
                break;
              case 2:
                Hive.registerAdapter<RecurringType>(
                    adapter as RecurringTypeAdapter);
                break;
              case 3:
                Hive.registerAdapter<finance.Category>(
                    adapter as finance.CategoryAdapter);
                break;
              case 4:
                Hive.registerAdapter<finance.CategoryTransactionType>(
                    adapter as finance.CategoryTransactionTypeAdapter);
                break;
              case 5:
                Hive.registerAdapter<Budget>(adapter as BudgetAdapter);
                break;
              case 6:
                Hive.registerAdapter<BudgetPeriod>(
                    adapter as BudgetPeriodAdapter);
                break;
              case 7:
                Hive.registerAdapter<FinancialGoal>(
                    adapter as FinancialGoalAdapter);
                break;
              case 8:
                Hive.registerAdapter<GoalType>(adapter as GoalTypeAdapter);
                break;
              default:
                throw Exception('Unknown adapter type ID: $typeId');
            }

            _registeredAdapters.add(typeId);
            debugPrint('FinanceArcade: Registered $name (typeId: $typeId)');
          } else {
            _registeredAdapters.add(typeId);
            debugPrint(
                'FinanceArcade: $name (typeId: $typeId) already registered - marking as complete');
          }
        } catch (e) {
          if (e.toString().contains('There is already a TypeAdapter')) {
            _registeredAdapters.add(typeId);
            debugPrint(
                'FinanceArcade: $name (typeId: $typeId) - duplicate resolved, continuing');
            continue;
          } else {
            debugPrint('FinanceArcade: Error registering $name: $e');
            rethrow;
          }
        }
      }

      _adaptersRegistered = true;
      debugPrint(
          'FinanceArcade: All adapters registered successfully (${_registeredAdapters.length} total)');
    } catch (e) {
      debugPrint('FinanceArcade: Critical error in adapter registration: $e');
      _adaptersRegistered = false;
      rethrow;
    }
  }

  /// Safely open all Hive boxes for FinanceArcade with duplicate protection
  static Future<void> _safeOpenBoxes() async {
    try {
      final boxConfigs = [
        {'name': transactionsBox, 'type': 'Transaction'},
        {'name': categoriesBox, 'type': 'Category'},
        {'name': budgetsBox, 'type': 'Budget'},
        {'name': goalsBox, 'type': 'FinancialGoal'},
        {'name': settingsBox, 'type': 'Settings'},
      ];

      for (final config in boxConfigs) {
        final boxName = config['name'] as String;
        final boxType = config['type'] as String;

        try {
          if (!Hive.isBoxOpen(boxName)) {
            switch (boxType) {
              case 'Transaction':
                await Hive.openBox<Transaction>(boxName);
                break;
              case 'Category':
                await Hive.openBox<finance.Category>(boxName);
                break;
              case 'Budget':
                await Hive.openBox<Budget>(boxName);
                break;
              case 'FinancialGoal':
                await Hive.openBox<FinancialGoal>(boxName);
                break;
              case 'Settings':
                await Hive.openBox(boxName);
                break;
            }
            debugPrint('FinanceArcade: Opened $boxType box ($boxName)');
          } else {
            debugPrint('FinanceArcade: $boxType box ($boxName) already open');
          }
        } catch (e) {
          debugPrint('FinanceArcade: Error opening $boxType box: $e');
          rethrow;
        }
      }

      debugPrint('FinanceArcade: All boxes opened successfully');
    } catch (e) {
      debugPrint('FinanceArcade: Critical error opening boxes: $e');
      rethrow;
    }
  }

  // Enhanced box getters with comprehensive safety checks for FinanceArcade
  static Box<Transaction> get transactions {
    _ensureInitialized();
    _ensureBoxOpen(transactionsBox, 'Transactions');
    return Hive.box<Transaction>(transactionsBox);
  }

  static Box<finance.Category> get categories {
    _ensureInitialized();
    _ensureBoxOpen(categoriesBox, 'Categories');
    return Hive.box<finance.Category>(categoriesBox);
  }

  static Box<Budget> get budgets {
    _ensureInitialized();
    _ensureBoxOpen(budgetsBox, 'Budgets');
    return Hive.box<Budget>(budgetsBox);
  }

  static Box<FinancialGoal> get goals {
    _ensureInitialized();
    _ensureBoxOpen(goalsBox, 'Goals');
    return Hive.box<FinancialGoal>(goalsBox);
  }

  static Box get settings {
    _ensureInitialized();
    _ensureBoxOpen(settingsBox, 'Settings');
    return Hive.box(settingsBox);
  }

  /// Ensure storage is initialized
  static void _ensureInitialized() {
    if (!_initialized) {
      throw Exception(
          'FinanceArcade: Storage not initialized. Call StorageService.init() first.');
    }
  }

  /// Ensure a specific box is open
  static void _ensureBoxOpen(String boxName, String boxDisplayName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw Exception(
          'FinanceArcade: $boxDisplayName box not open. Call StorageService.init() first.');
    }
  }

  // FinanceArcade PIN Management with arcade-style security
  Future<String?> getPin() async {
    try {
      return StorageService.settings.get('financearcade_pin') as String?;
    } catch (e) {
      debugPrint('FinanceArcade: Error getting PIN: $e');
      return null;
    }
  }

  Future<void> setPin(String pin) async {
    try {
      await StorageService.settings.put('financearcade_pin', pin);
      await StorageService.settings.put('financearcade_pin_enabled', true);
      debugPrint('FinanceArcade: PIN security enabled');
      notifyListeners();
    } catch (e) {
      debugPrint('FinanceArcade: Error setting PIN: $e');
      rethrow;
    }
  }

  Future<void> removePin() async {
    try {
      await StorageService.settings.delete('financearcade_pin');
      await StorageService.settings.put('financearcade_pin_enabled', false);
      await StorageService.settings.put('financearcade_pin_attempts', 0);
      debugPrint('FinanceArcade: PIN security disabled');
      notifyListeners();
    } catch (e) {
      debugPrint('FinanceArcade: Error removing PIN: $e');
      rethrow;
    }
  }

  bool get isPinEnabled {
    try {
      return StorageService.settings
          .get('financearcade_pin_enabled', defaultValue: false) as bool;
    } catch (e) {
      debugPrint('FinanceArcade: Error checking PIN status: $e');
      return false;
    }
  }

  Future<bool> verifyPin(String inputPin) async {
    try {
      final savedPin = await getPin();
      final isValid = savedPin != null && savedPin == inputPin;

      if (isValid) {
        await resetPinAttempts();
        debugPrint('FinanceArcade: PIN verification successful');
      } else {
        await incrementPinAttempts();
        debugPrint('FinanceArcade: PIN verification failed');
      }

      return isValid;
    } catch (e) {
      debugPrint('FinanceArcade: Error verifying PIN: $e');
      return false;
    }
  }

  // FinanceArcade security - PIN attempt tracking
  int get pinAttempts {
    try {
      return StorageService.settings
          .get('financearcade_pin_attempts', defaultValue: 0) as int;
    } catch (e) {
      debugPrint('FinanceArcade: Error getting PIN attempts: $e');
      return 0;
    }
  }

  Future<void> incrementPinAttempts() async {
    try {
      final attempts = pinAttempts + 1;
      await StorageService.settings.put('financearcade_pin_attempts', attempts);
      debugPrint('FinanceArcade: PIN attempts: $attempts');
      notifyListeners();
    } catch (e) {
      debugPrint('FinanceArcade: Error incrementing PIN attempts: $e');
    }
  }

  Future<void> resetPinAttempts() async {
    try {
      await StorageService.settings.put('financearcade_pin_attempts', 0);
      debugPrint('FinanceArcade: PIN attempts reset');
      notifyListeners();
    } catch (e) {
      debugPrint('FinanceArcade: Error resetting PIN attempts: $e');
    }
  }

  // FinanceArcade theme management - prioritizing dark mode experience
  bool get isDarkMode {
    try {
      return StorageService.settings
          .get('financearcade_dark_mode', defaultValue: true) as bool;
    } catch (e) {
      debugPrint('FinanceArcade: Error getting theme mode: $e');
      return true; // Default to dark mode for arcade experience
    }
  }

  Future<void> setDarkMode(bool isDark) async {
    try {
      await StorageService.settings.put('financearcade_dark_mode', isDark);
      debugPrint(
          'FinanceArcade: Theme set to ${isDark ? 'dark' : 'light'} mode');
      notifyListeners();
    } catch (e) {
      debugPrint('FinanceArcade: Error setting theme mode: $e');
      rethrow;
    }
  }

  // Multi-currency support for FinanceArcade
  String get selectedCurrency {
    try {
      return StorageService.settings
          .get('financearcade_currency', defaultValue: 'USD') as String;
    } catch (e) {
      debugPrint('FinanceArcade: Error getting currency: $e');
      return 'USD';
    }
  }

  Future<void> setCurrency(String currency) async {
    try {
      await StorageService.settings.put('financearcade_currency', currency);
      debugPrint('FinanceArcade: Currency set to $currency');
      notifyListeners();
    } catch (e) {
      debugPrint('FinanceArcade: Error setting currency: $e');
      rethrow;
    }
  }

  // Legacy methods for backward compatibility
  Future<bool> isPinChecked() async {
    return isPinEnabled;
  }

  /// Initialize FinanceArcade default categories with arcade-style colors and icons
  static Future<void> _initializeDefaultCategories() async {
    try {
      final categoriesBox = StorageService.categories;

      if (categoriesBox.isEmpty) {
        final arcadeCategories = [
          // FinanceArcade Expense Categories - Neon/Electric theme
          finance.Category(
            id: 'financearcade_food',
            name: 'Food & Dining',
            colorValue: 0xFFFF6B6B, // Electric Red
            iconCodePoint: 0xe57a, // restaurant
            isDefault: true,
            type: finance.CategoryTransactionType.expense,
          ),
          finance.Category(
            id: 'financearcade_transport',
            name: 'Transportation',
            colorValue: 0xFF4ECDC4, // Neon Teal
            iconCodePoint: 0xe530, // directions_car
            isDefault: true,
            type: finance.CategoryTransactionType.expense,
          ),
          finance.Category(
            id: 'financearcade_bills',
            name: 'Bills & Utilities',
            colorValue: 0xFF45B7D1, // Electric Blue
            iconCodePoint: 0xe8b6, // receipt
            isDefault: true,
            type: finance.CategoryTransactionType.expense,
          ),
          finance.Category(
            id: 'financearcade_shopping',
            name: 'Shopping',
            colorValue: 0xFF96CEB4, // Arcade Green
            iconCodePoint: 0xe8cc, // shopping_bag
            isDefault: true,
            type: finance.CategoryTransactionType.expense,
          ),
          finance.Category(
            id: 'financearcade_entertainment',
            name: 'Entertainment',
            colorValue: 0xFFFCEAA6, // Neon Yellow
            iconCodePoint: 0xe419, // movie
            isDefault: true,
            type: finance.CategoryTransactionType.expense,
          ),
          finance.Category(
            id: 'financearcade_healthcare',
            name: 'Healthcare',
            colorValue: 0xFFF38BA8, // Electric Pink
            iconCodePoint: 0xe588, // local_hospital
            isDefault: true,
            type: finance.CategoryTransactionType.expense,
          ),

          // FinanceArcade Income Categories - Success/Growth theme
          finance.Category(
            id: 'financearcade_salary',
            name: 'Salary',
            colorValue: 0xFF00C851, // Success Green
            iconCodePoint: 0xe8ac, // work
            isDefault: true,
            type: finance.CategoryTransactionType.income,
          ),
          finance.Category(
            id: 'financearcade_freelance',
            name: 'Freelance',
            colorValue: 0xFF00C9FF, // Cyber Blue
            iconCodePoint: 0xe30d, // laptop
            isDefault: true,
            type: finance.CategoryTransactionType.income,
          ),
          finance.Category(
            id: 'financearcade_investment',
            name: 'Investment',
            colorValue: 0xFFFFBB33, // Gold Rush
            iconCodePoint: 0xe8d0, // trending_up
            isDefault: true,
            type: finance.CategoryTransactionType.income,
          ),
          finance.Category(
            id: 'financearcade_business',
            name: 'Business',
            colorValue: 0xFF9C27B0, // Electric Purple
            iconCodePoint: 0xe1af, // business
            isDefault: true,
            type: finance.CategoryTransactionType.income,
          ),
        ];

        for (final category in arcadeCategories) {
          await categoriesBox.put(category.id, category);
        }

        debugPrint(
            'FinanceArcade: Initialized ${arcadeCategories.length} arcade-style categories');
      }
    } catch (e) {
      debugPrint('FinanceArcade: Error initializing default categories: $e');
      rethrow;
    }
  }

  /// Clear all FinanceArcade data with proper cleanup and type safety
  static Future<void> clearAllData() async {
    try {
      // Ensure we're initialized before attempting to clear data
      if (!_initialized) {
        debugPrint(
            'FinanceArcade: Storage not initialized for clearAllData, initializing...');
        await init();
      }

      // Clear data with proper type safety
      if (Hive.isBoxOpen(transactionsBox)) {
        final transactionsBox =
            Hive.box<Transaction>(StorageService.transactionsBox);
        await transactionsBox.clear();
        debugPrint('FinanceArcade: Cleared transactions');
      }

      if (Hive.isBoxOpen(categoriesBox)) {
        final categoriesBox =
            Hive.box<finance.Category>(StorageService.categoriesBox);
        await categoriesBox.clear();
        debugPrint('FinanceArcade: Cleared categories');
      }

      if (Hive.isBoxOpen(budgetsBox)) {
        final budgetsBox = Hive.box<Budget>(StorageService.budgetsBox);
        await budgetsBox.clear();
        debugPrint('FinanceArcade: Cleared budgets');
      }

      if (Hive.isBoxOpen(goalsBox)) {
        final goalsBox = Hive.box<FinancialGoal>(StorageService.goalsBox);
        await goalsBox.clear();
        debugPrint('FinanceArcade: Cleared goals');
      }

      // Handle settings box separately (untyped box)
      if (Hive.isBoxOpen(settingsBox)) {
        final settingsBox = Hive.box(StorageService.settingsBox);

        // Keep essential FinanceArcade settings
        final essentialSettings = {
          'financearcade_dark_mode': settingsBox.get('financearcade_dark_mode'),
          'financearcade_currency': settingsBox.get('financearcade_currency'),
          'financearcade_pin': settingsBox.get('financearcade_pin'),
          'financearcade_pin_enabled':
              settingsBox.get('financearcade_pin_enabled'),
        };

        await settingsBox.clear();

        // Restore essential settings
        for (final entry in essentialSettings.entries) {
          if (entry.value != null) {
            await settingsBox.put(entry.key, entry.value);
          }
        }
        debugPrint('FinanceArcade: Cleared and restored settings');
      }

      // Reinitialize arcade categories
      await _initializeDefaultCategories();

      debugPrint(
          'FinanceArcade: All data cleared and reinitialized successfully');
    } catch (e) {
      debugPrint('FinanceArcade: Error clearing data: $e');
      rethrow;
    }
  }

  /// Get FinanceArcade storage statistics for dashboard with type safety
  static Map<String, int> getStorageStats() {
    try {
      if (!_initialized) {
        debugPrint('FinanceArcade: Storage not initialized for stats');
        return {
          'transactions': 0,
          'categories': 0,
          'budgets': 0,
          'goals': 0,
          'settings': 0,
        };
      }

      return {
        'transactions': Hive.isBoxOpen(transactionsBox)
            ? Hive.box<Transaction>(transactionsBox).length
            : 0,
        'categories': Hive.isBoxOpen(categoriesBox)
            ? Hive.box<finance.Category>(categoriesBox).length
            : 0,
        'budgets': Hive.isBoxOpen(budgetsBox)
            ? Hive.box<Budget>(budgetsBox).length
            : 0,
        'goals': Hive.isBoxOpen(goalsBox)
            ? Hive.box<FinancialGoal>(goalsBox).length
            : 0,
        'settings':
            Hive.isBoxOpen(settingsBox) ? Hive.box(settingsBox).length : 0,
      };
    } catch (e) {
      debugPrint('FinanceArcade: Error getting storage stats: $e');
      return {
        'transactions': 0,
        'categories': 0,
        'budgets': 0,
        'goals': 0,
        'settings': 0,
      };
    }
  }

  /// Check if this is first launch for FinanceArcade onboarding
  static bool get isFirstLaunch {
    try {
      if (!_initialized || !Hive.isBoxOpen(settingsBox)) {
        return true;
      }
      return Hive.box(settingsBox)
          .get('financearcade_first_launch', defaultValue: true) as bool;
    } catch (e) {
      debugPrint('FinanceArcade: Error checking first launch: $e');
      return true;
    }
  }

  static Future<void> setFirstLaunchComplete() async {
    try {
      if (_initialized && Hive.isBoxOpen(settingsBox)) {
        await Hive.box(settingsBox).put('financearcade_first_launch', false);
        debugPrint('FinanceArcade: First launch completed');
      }
    } catch (e) {
      debugPrint('FinanceArcade: Error setting first launch complete: $e');
    }
  }

  /// Get initialization status for debugging
  static bool get isInitialized => _initialized;

  /// Get adapter registration status for debugging
  static bool get areAdaptersRegistered => _adaptersRegistered;

  /// Get registered adapters count
  static int get registeredAdaptersCount => _registeredAdapters.length;

  /// Force reset initialization flag (for testing/debugging)
  static void resetInitialization() {
    _initialized = false;
    _adaptersRegistered = false;
    _registeredAdapters.clear();
    debugPrint('FinanceArcade: Initialization flags reset');
  }

  /// Close all boxes safely for app lifecycle management
  static Future<void> closeAll() async {
    try {
      final boxNames = [
        transactionsBox,
        categoriesBox,
        budgetsBox,
        goalsBox,
        settingsBox
      ];

      for (final boxName in boxNames) {
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).close();
          debugPrint('FinanceArcade: Closed box: $boxName');
        }
      }

      _initialized = false;
      debugPrint('FinanceArcade: All boxes closed and state reset');
    } catch (e) {
      debugPrint('FinanceArcade: Error closing boxes: $e');
      rethrow;
    }
  }

  /// Get comprehensive storage health information for FinanceArcade diagnostics
  static Map<String, dynamic> getStorageHealth() {
    try {
      return {
        'initialized': _initialized,
        'adapters_registered': _adaptersRegistered,
        'registered_adapters_count': _registeredAdapters.length,
        'registered_adapter_ids': _registeredAdapters.toList(),
        'boxes_status': {
          'transactions': Hive.isBoxOpen(transactionsBox),
          'categories': Hive.isBoxOpen(categoriesBox),
          'budgets': Hive.isBoxOpen(budgetsBox),
          'goals': Hive.isBoxOpen(goalsBox),
          'settings': Hive.isBoxOpen(settingsBox),
        },
        'hive_adapter_registry': {
          for (int i = 0; i <= 8; i++) 'type_$i': Hive.isAdapterRegistered(i),
        },
        'stats': _initialized ? getStorageStats() : null,
        'timestamp': DateTime.now().toIso8601String(),
        'platform': kIsWeb ? 'web' : 'native',
      };
    } catch (e) {
      debugPrint('FinanceArcade: Error getting storage health: $e');
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }
}

