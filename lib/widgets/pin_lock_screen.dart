import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../screens/main_screen.dart';

class PinLockScreen extends StatefulWidget {
  final VoidCallback? onUnlocked;
  final bool canGoBack;

  const PinLockScreen({
    super.key,
    this.onUnlocked,
    this.canGoBack = false,
  });

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen>
    with TickerProviderStateMixin {
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool _isError = false;
  bool _isLoading = false;
  int _attempts = 0;
  final int _maxAttempts = 5;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _loadAttempts();
  }

  Future<void> _loadAttempts() async {
    final storageService = context.read<StorageService>();
    _attempts = storageService.pinAttempts;
  }

  Future<void> _verifyPin() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      final storageService = context.read<StorageService>();
      final isValid = await storageService.verifyPin(_pinController.text);

      if (isValid) {
        // Reset attempts on successful unlock
        await storageService.resetPinAttempts();

        // Haptic feedback for success
        HapticFeedback.mediumImpact();

        if (widget.onUnlocked != null) {
          widget.onUnlocked!();
        } else {
          // Navigate to main screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }
      } else {
        // Increment failed attempts
        await storageService.incrementPinAttempts();
        _attempts = storageService.pinAttempts;

        // Shake animation and haptic feedback for error
        _shakeController.forward().then((_) {
          _shakeController.reverse();
        });
        HapticFeedback.heavyImpact();

        setState(() {
          _isError = true;
          _isLoading = false;
        });

        _pinController.clear();

        // Check if max attempts reached
        if (_attempts >= _maxAttempts) {
          _showMaxAttemptsDialog();
        }
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error verifying PIN: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _showMaxAttemptsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.red[400], size: 28),
            const SizedBox(width: 12),
            const Text('Too Many Attempts'),
          ],
        ),
        content: Text(
          'You have exceeded the maximum number of PIN attempts. Please try again later.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset attempts and allow retry
              context.read<StorageService>().resetPinAttempts();
              _attempts = 0;
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: widget.canGoBack
          ? AppBar(
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset:
                    _isError ? Offset(_shakeAnimation.value, 0) : Offset.zero,
                child: Card(
                  elevation: 12,
                  shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.surface,
                          theme.colorScheme.surface.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Lock icon with glow effect
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.lock,
                                size: 48,
                                color: theme.colorScheme.primary,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Title
                            Text(
                              'Enter PIN',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Subtitle with attempt counter
                            if (_attempts > 0)
                              Text(
                                'Attempts: $_attempts/$_maxAttempts',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: _attempts >= _maxAttempts - 1
                                      ? Colors.red
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                            const SizedBox(height: 32),

                            // PIN Input Field
                            TextFormField(
                              controller: _pinController,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 8,
                              ),
                              decoration: InputDecoration(
                                hintText: '• • • • • •',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.3),
                                  letterSpacing: 8,
                                ),
                                prefixIcon: Icon(
                                  Icons.key,
                                  color: theme.colorScheme.primary,
                                  size: 24,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface
                                    .withValues(alpha: 0.5),
                                counterText: '',
                                errorText: _isError
                                    ? 'Incorrect PIN. Try again.'
                                    : null,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your PIN';
                                }
                                if (value.length < 4) {
                                  return 'PIN must be at least 4 digits';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _verifyPin(),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Unlock Button
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.primary
                                          .withValues(alpha: 0.8),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  icon: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : const Icon(Icons.lock_open, size: 24),
                                  label: Text(
                                    _isLoading ? 'Unlocking...' : 'Unlock',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: _isLoading ? null : _verifyPin,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
// Commit 17: 2025-02-06T17:24:50
// Commit 19: 2025-02-07T07:35:23
// Commit 190: 2025-03-29T18:31:45
// Commit 191: 2025-03-30T01:16:23
// Commit 11: 2025-02-04T22:49:25
// Commit 14: 2025-02-05T20:40:21
// Commit 15: 2025-02-06T03:23:40
// Commit 55: 2025-02-17T22:32:29
// Commit 57: 2025-02-18T12:46:31
// Commit 61: 2025-02-19T17:05:50
// Commit 66: 2025-02-21T04:51:54
// Commit 85: 2025-02-26T19:31:51
// Commit 115: 2025-03-07T15:29:04
// Commit 156: 2025-03-19T17:46:42
// Commit 168: 2025-03-23T07:02:30
// Commit 169: 2025-03-23T14:18:29
// Commit 188: 2025-03-29T04:03:36
// Commit 198: 2025-04-01T03:44:57
// Commit 24: 2025-02-08T19:06:21
// Commit 34: 2025-02-11T18:37:01
// Commit 92: 2025-02-28T20:32:11
// Commit 103: 2025-03-04T02:13:19
// Commit 107: 2025-03-05T07:04:06
// Commit 148: 2025-03-17T09:04:53
// Commit 160: 2025-03-20T22:37:58
// Commit 186: 2025-03-28T13:55:03
// Commit 4: 2025-02-02T21:39:16
// Commit 16: 2025-02-06T10:46:22
// Commit 98: 2025-03-02T15:41:42
// Commit 131: 2025-03-12T08:39:05
// Commit 132: 2025-03-12T15:32:45
// Commit 137: 2025-03-14T03:20:11
// Commit 162: 2025-03-21T12:40:24
// Commit 179: 2025-03-26T12:44:22
// Commit 2: 2025-02-02T07:27:47
// Commit 6: 2025-02-03T11:25:18
// Commit 10: 2025-02-04T16:09:06
// Commit 11: 2025-02-04T23:35:52
// Commit 33: 2025-02-11T11:21:02
// Commit 49: 2025-02-16T03:54:31
// Commit 59: 2025-02-19T03:14:47
// Commit 110: 2025-03-06T04:00:00
// Commit 122: 2025-03-09T17:29:11
// Commit 143: 2025-03-15T21:53:50
// Commit 158: 2025-03-20T07:35:49
// Commit 185: 2025-03-28T07:00:15
// Commit 188: 2025-03-29T04:13:18
// Commit 13: 2025-02-05T13:50:13
// Commit 26: 2025-02-09T09:28:50
