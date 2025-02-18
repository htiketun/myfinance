import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';

class PinSettingsCard extends StatefulWidget {
  const PinSettingsCard({super.key});

  @override
  State<PinSettingsCard> createState() => _PinSettingsCardState();
}

class _PinSettingsCardState extends State<PinSettingsCard> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _setPin() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final storageService = context.read<StorageService>();
      await storageService.setPin(_pinController.text);

      HapticFeedback.mediumImpact();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'PIN set successfully!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting PIN: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSetPinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Set PIN'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Enter PIN',
                  hintText: 'At least 4 digits',
                  prefixIcon: Icon(Icons.key),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a PIN';
                  }
                  if (value.length < 4) {
                    return 'PIN must be at least 4 digits';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Confirm PIN',
                  hintText: 'Enter PIN again',
                  prefixIcon: Icon(Icons.key),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your PIN';
                  }
                  if (value != _pinController.text) {
                    return 'PINs do not match';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pinController.clear();
              _confirmPinController.clear();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _setPin,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Set PIN'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storageService, child) {
        final hasPinSet = storageService.isPinEnabled;

        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                hasPinSet ? Icons.lock : Icons.lock_open,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              hasPinSet ? 'PIN Enabled' : 'Set PIN',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              hasPinSet
                  ? 'Your app is secured with a PIN'
                  : 'Secure your app with a PIN',
            ),
            trailing: hasPinSet
                ? PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'remove') {
                        await storageService.removePin();
                        if (mounted) { 
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('PIN removed successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } else if (value == 'change') {
                        _showSetPinDialog();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'change',
                        child: Text('Change PIN'),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Remove PIN'),
                      ),
                    ],
                  )
                : IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _showSetPinDialog,
                  ),
          ),
        );
      },
    );
  }
}
// Commit 126: 2025-03-10T21:31:01
// Commit 152: 2025-03-18T13:35:23
// Commit 125: 2025-03-10T14:15:57
// Commit 21: 2025-02-07T21:43:47
// Commit 35: 2025-02-12T01:40:36
// Commit 42: 2025-02-14T03:04:16
// Commit 90: 2025-02-28T06:47:21
// Commit 154: 2025-03-19T03:41:28
// Commit 167: 2025-03-22T23:28:20
// Commit 185: 2025-03-28T07:03:45
// Commit 10: 2025-02-04T15:59:51
// Commit 13: 2025-02-05T13:23:18
// Commit 32: 2025-02-11T04:03:15
// Commit 63: 2025-02-20T07:46:09
// Commit 84: 2025-02-26T11:50:53
// Commit 90: 2025-02-28T06:57:25
// Commit 96: 2025-03-02T00:41:46
// Commit 111: 2025-03-06T11:17:14
// Commit 127: 2025-03-11T05:03:29
// Commit 150: 2025-03-17T23:45:32
// Commit 191: 2025-03-30T02:10:08
// Commit 64: 2025-02-20T14:10:04
// Commit 88: 2025-02-27T16:18:42
// Commit 114: 2025-03-07T08:38:44
// Commit 115: 2025-03-07T15:22:03
// Commit 166: 2025-03-22T16:14:47
// Commit 187: 2025-03-28T21:04:57
// Commit 71: 2025-02-22T15:56:20
// Commit 72: 2025-02-22T23:08:29
// Commit 76: 2025-02-24T03:46:59
// Commit 96: 2025-03-02T01:31:43
// Commit 109: 2025-03-05T20:57:23
// Commit 137: 2025-03-14T03:19:58
// Commit 139: 2025-03-14T17:37:34
// Commit 145: 2025-03-16T12:01:07
// Commit 165: 2025-03-22T09:48:35
// Commit 196: 2025-03-31T12:47:27
// Commit 20: 2025-02-07T15:13:00
// Commit 57: 2025-02-18T13:03:56
