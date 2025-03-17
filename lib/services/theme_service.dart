import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark mode

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeService() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 2; // Default to dark (2)
    
    switch (themeIndex) {
      case 0:
        _themeMode = ThemeMode.light;
        break;
      case 1:
        _themeMode = ThemeMode.system;
        break;
      case 2:
      default:
        _themeMode = ThemeMode.dark;
        break;
    }
    
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    int themeIndex = 2; // Default to dark
    
    switch (mode) {
      case ThemeMode.light:
        themeIndex = 0;
        break;
      case ThemeMode.system:
        themeIndex = 1;
        break;
      case ThemeMode.dark:
        themeIndex = 2;
        break;
    }
    
    await prefs.setInt(_themeKey, themeIndex);
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}// Commit 3: 2025-02-02T14:37:32
// Commit 160: 2025-03-20T21:45:51
// Commit 164: 2025-03-22T02:33:49
// Commit 182: 2025-03-27T10:15:12
// Commit 65: 2025-02-20T21:54:01
// Commit 120: 2025-03-09T02:54:07
// Commit 6: 2025-02-03T11:42:06
// Commit 9: 2025-02-04T09:18:34
// Commit 16: 2025-02-06T10:44:50
// Commit 25: 2025-02-09T02:03:35
// Commit 56: 2025-02-18T05:29:45
// Commit 57: 2025-02-18T12:46:31
// Commit 70: 2025-02-22T09:00:45
// Commit 80: 2025-02-25T08:10:29
// Commit 81: 2025-02-25T14:52:34
// Commit 88: 2025-02-27T16:06:28
// Commit 97: 2025-03-02T08:27:38
// Commit 102: 2025-03-03T19:58:20
// Commit 130: 2025-03-12T01:23:23
// Commit 147: 2025-03-17T02:30:24
// Commit 155: 2025-03-19T10:24:48
// Commit 156: 2025-03-19T17:46:42
// Commit 165: 2025-03-22T09:32:17
// Commit 186: 2025-03-28T14:04:25
// Commit 9: 2025-02-04T08:53:44
// Commit 46: 2025-02-15T06:42:00
// Commit 49: 2025-02-16T04:22:16
// Commit 55: 2025-02-17T22:58:57
// Commit 65: 2025-02-20T21:10:39
// Commit 66: 2025-02-21T04:58:28
// Commit 72: 2025-02-22T23:26:34
// Commit 89: 2025-02-27T23:58:58
// Commit 99: 2025-03-02T22:37:04
// Commit 102: 2025-03-03T19:53:18
// Commit 132: 2025-03-12T16:18:03
// Commit 148: 2025-03-17T09:04:53
// Commit 163: 2025-03-21T19:46:11
// Commit 170: 2025-03-23T21:05:30
// Commit 171: 2025-03-24T04:04:37
// Commit 173: 2025-03-24T18:07:15
// Commit 7: 2025-02-03T19:08:55
// Commit 12: 2025-02-05T06:04:06
// Commit 25: 2025-02-09T02:11:58
// Commit 48: 2025-02-15T21:04:08
// Commit 67: 2025-02-21T11:55:23
// Commit 68: 2025-02-21T18:45:00
// Commit 81: 2025-02-25T15:06:03
// Commit 84: 2025-02-26T12:22:49
// Commit 87: 2025-02-27T09:18:14
// Commit 97: 2025-03-02T08:21:04
// Commit 104: 2025-03-04T09:35:35
// Commit 116: 2025-03-07T23:05:15
// Commit 123: 2025-03-10T00:37:37
// Commit 127: 2025-03-11T04:27:12
// Commit 152: 2025-03-18T13:24:51
// Commit 191: 2025-03-30T01:17:01
// Commit 195: 2025-03-31T05:36:04
// Commit 3: 2025-02-02T15:00:07
// Commit 5: 2025-02-03T05:02:15
// Commit 9: 2025-02-04T09:32:43
// Commit 17: 2025-02-06T17:44:18
// Commit 18: 2025-02-07T00:42:18
// Commit 25: 2025-02-09T02:50:10
// Commit 52: 2025-02-17T01:52:14
// Commit 59: 2025-02-19T03:14:47
// Commit 79: 2025-02-25T00:31:59
// Commit 127: 2025-03-11T04:41:31
// Commit 136: 2025-03-13T20:06:37
// Commit 168: 2025-03-23T07:16:15
// Commit 189: 2025-03-29T11:03:01
// Commit 200: 2025-04-01T17:06:08
// Commit 14: 2025-02-05T20:34:13
// Commit 23: 2025-02-08T11:49:40
// Commit 42: 2025-02-14T02:58:43
// Commit 43: 2025-02-14T09:44:28
// Commit 50: 2025-02-16T11:47:59
// Commit 54: 2025-02-17T15:35:57
// Commit 59: 2025-02-19T03:33:58
// Commit 60: 2025-02-19T10:34:50
// Commit 61: 2025-02-19T16:55:45
// Commit 64: 2025-02-20T14:24:19
// Commit 75: 2025-02-23T20:21:55
// Commit 104: 2025-03-04T09:55:17
// Commit 110: 2025-03-06T03:53:47
// Commit 116: 2025-03-07T23:00:12
// Commit 122: 2025-03-09T17:15:27
// Commit 132: 2025-03-12T15:50:21
// Commit 150: 2025-03-17T23:26:43
