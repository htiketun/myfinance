import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/storage_service.dart';
import 'services/transaction_service.dart';
import 'services/category_service.dart';
import 'services/budget_service.dart';
import 'services/theme_service.dart';
import 'screens/main_screen.dart';
import 'themes/app_theme.dart';
import 'widgets/pin_lock_screen.dart';

/// FinanceArcade - Flutter Finance Management App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive
    await Hive.initFlutter();
    await StorageService.init();
  } catch (e) {
    print('FinanceArcade: Critical error during initialization: $e');

    // If initialization fails due to corrupted data, clear all data and retry
    if (e.toString().contains('not a subtype') ||
        e.toString().contains('type') ||
        e.toString().contains('cast')) {
      print('FinanceArcade: Detected type corruption, clearing data...');
      try {
        await Hive.initFlutter();
        await Hive.deleteFromDisk();
        await StorageService.init();
        print('FinanceArcade: Data cleared and reinitialized successfully');
      } catch (clearError) {
        print('FinanceArcade: Failed to clear corrupted data: $clearError');
        rethrow;
      }
    } else {
      rethrow;
    }
  }

  runApp(const FinanceArcadeApp());
}

class FinanceArcadeApp extends StatelessWidget {
  const FinanceArcadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services following FinanceArcade architecture
        ChangeNotifierProvider(create: (_) => StorageService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => CategoryService()),
        ChangeNotifierProvider(create: (_) => TransactionService()),
        ChangeNotifierProvider(create: (_) => BudgetService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'FinanceArcade',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            home: const PinGate(),
            // FinanceArcade - Arcade-style app configuration
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(
                    1.0,
                  ), // Consistent arcade UI
                ),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(
                    scrollbars: false, // Clean arcade-style scrolling
                  ),
                  child: child!,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PinGate extends StatefulWidget {
  const PinGate({super.key});

  @override
  State<PinGate> createState() => _PinGateState();
}

class _PinGateState extends State<PinGate> with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _showPinLock = false;
  late AnimationController _logoAnimationController;
  late Animation<double> _logoScaleAnimation;
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkPinStatus();
  }

  void _initAnimations() {
    // Logo entrance animation
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Pulse animation for loading
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _logoAnimationController.forward();
    _pulseAnimationController.repeat(reverse: true);
  }

  Future<void> _checkPinStatus() async {
    try {
      // Add slight delay for smooth loading experience
      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      final storageService = context.read<StorageService>();
      final pin = await storageService.getPin();
      final isPinEnabled = storageService.isPinEnabled;

      if (mounted) {
        setState(() {
          _showPinLock = pin != null && pin.isNotEmpty && isPinEnabled;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('FinanceArcade: Error checking PIN status: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showPinLock = false;
        });
      }
    }
  }

  void _onPinUnlocked() {
    setState(() {
      _showPinLock = false;
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_logoScaleAnimation, _pulseAnimation]),
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // FinanceArcade Logo with animations
                  Transform.scale(
                    scale: _logoScaleAnimation.value * _pulseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.account_balance_wallet,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // FinanceArcade Title
                  Text(
                    'FinanceArcade',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Arcade-Style Finance Management',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Loading indicator
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Initializing...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    }

    if (_showPinLock) {
      return PinLockScreen(onUnlocked: _onPinUnlocked);
    }

    return const MainScreen();
  }
}

/// Error fallback app for initialization failures
class FinanceArcadeErrorApp extends StatelessWidget {
  const FinanceArcadeErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinanceArcade - Error',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 24),
              Text(
                'FinanceArcade Initialization Error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Please restart the app or contact support',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

