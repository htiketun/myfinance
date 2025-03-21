import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\K ',
    decimalDigits: 2,
  );

  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatWithoutSymbol(double amount) {
    return NumberFormat('#,##0.00').format(amount);
  }
}

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(date);
  }
}

class AppConstants {
  // Colors
  static const int primaryNeonValue = 0xFF00FFFF;
  static const int secondaryNeonValue = 0xFFFF00FF;
  static const int accentNeonValue = 0xFF00FF00;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Sizes
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 20.0;

  // Spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
}
// Commit 50: 2025-02-16T11:53:55
// Commit 56: 2025-02-18T05:30:46
// Commit 57: 2025-02-18T13:16:09
// Commit 59: 2025-02-19T03:25:37
// Commit 77: 2025-02-24T10:46:09
// Commit 78: 2025-02-24T17:35:03
// Commit 85: 2025-02-26T19:37:17
// Commit 98: 2025-03-02T15:06:35
// Commit 100: 2025-03-03T05:53:23
// Commit 107: 2025-03-05T06:58:06
// Commit 129: 2025-03-11T18:27:52
// Commit 186: 2025-03-28T14:26:20
// Commit 192: 2025-03-30T08:27:56
// Commit 6: 2025-02-03T11:58:21
// Commit 24: 2025-02-08T19:25:20
// Commit 25: 2025-02-09T02:01:05
// Commit 62: 2025-02-20T00:00:36
// Commit 63: 2025-02-20T07:23:01
// Commit 92: 2025-02-28T20:27:37
// Commit 96: 2025-03-02T00:49:54
// Commit 157: 2025-03-20T01:24:27
// Commit 168: 2025-03-23T07:05:16
// Commit 188: 2025-03-29T04:21:10
// Commit 4: 2025-02-02T21:52:12
// Commit 6: 2025-02-03T11:42:06
// Commit 7: 2025-02-03T19:12:02
// Commit 8: 2025-02-04T02:26:26
// Commit 10: 2025-02-04T16:06:39
// Commit 12: 2025-02-05T06:46:23
// Commit 16: 2025-02-06T10:44:50
// Commit 20: 2025-02-07T14:53:19
// Commit 23: 2025-02-08T12:37:50
// Commit 26: 2025-02-09T09:00:26
// Commit 28: 2025-02-09T23:48:50
// Commit 29: 2025-02-10T06:22:56
// Commit 33: 2025-02-11T11:12:02
// Commit 40: 2025-02-13T12:54:02
// Commit 42: 2025-02-14T03:04:16
// Commit 43: 2025-02-14T10:16:12
// Commit 44: 2025-02-14T16:38:49
// Commit 46: 2025-02-15T07:32:17
// Commit 55: 2025-02-17T22:32:29
// Commit 56: 2025-02-18T05:29:45
// Commit 60: 2025-02-19T10:14:31
// Commit 62: 2025-02-20T00:23:51
// Commit 66: 2025-02-21T04:51:54
// Commit 68: 2025-02-21T18:50:13
// Commit 79: 2025-02-25T01:10:33
// Commit 80: 2025-02-25T08:10:29
// Commit 82: 2025-02-25T21:44:55
// Commit 89: 2025-02-27T23:12:28
// Commit 93: 2025-03-01T04:01:42
// Commit 94: 2025-03-01T11:14:58
// Commit 98: 2025-03-02T15:44:55
// Commit 101: 2025-03-03T12:19:11
// Commit 107: 2025-03-05T07:10:10
// Commit 108: 2025-03-05T14:09:17
// Commit 110: 2025-03-06T03:58:32
// Commit 111: 2025-03-06T11:25:58
// Commit 112: 2025-03-06T18:49:30
// Commit 116: 2025-03-07T23:02:58
// Commit 124: 2025-03-10T07:42:14
// Commit 127: 2025-03-11T04:07:55
// Commit 134: 2025-03-13T05:49:00
// Commit 138: 2025-03-14T10:38:16
// Commit 139: 2025-03-14T17:43:07
// Commit 140: 2025-03-15T00:10:46
// Commit 142: 2025-03-15T14:54:45
// Commit 144: 2025-03-16T05:08:24
// Commit 152: 2025-03-18T13:43:43
// Commit 154: 2025-03-19T03:41:28
// Commit 156: 2025-03-19T17:46:42
// Commit 159: 2025-03-20T14:45:18
// Commit 168: 2025-03-23T07:02:30
// Commit 172: 2025-03-24T11:34:37
// Commit 196: 2025-03-31T13:32:42
// Commit 197: 2025-03-31T20:08:08
// Commit 2: 2025-02-02T07:39:51
// Commit 3: 2025-02-02T15:03:35
// Commit 4: 2025-02-02T21:52:55
// Commit 15: 2025-02-06T03:19:23
// Commit 17: 2025-02-06T18:13:22
// Commit 18: 2025-02-07T00:29:01
// Commit 21: 2025-02-07T21:54:04
// Commit 25: 2025-02-09T02:55:07
// Commit 26: 2025-02-09T09:46:58
// Commit 28: 2025-02-09T23:52:14
// Commit 32: 2025-02-11T04:03:15
// Commit 36: 2025-02-12T08:01:32
// Commit 38: 2025-02-12T22:56:15
// Commit 39: 2025-02-13T05:28:38
// Commit 44: 2025-02-14T17:26:08
// Commit 47: 2025-02-15T13:40:49
// Commit 51: 2025-02-16T18:23:39
// Commit 52: 2025-02-17T01:42:41
// Commit 58: 2025-02-18T20:30:42
// Commit 59: 2025-02-19T03:25:48
// Commit 60: 2025-02-19T10:06:23
// Commit 61: 2025-02-19T17:38:17
// Commit 62: 2025-02-20T00:08:00
// Commit 68: 2025-02-21T18:32:10
// Commit 73: 2025-02-23T06:07:34
// Commit 78: 2025-02-24T17:53:23
// Commit 79: 2025-02-25T01:08:16
// Commit 83: 2025-02-26T05:05:17
// Commit 84: 2025-02-26T11:50:53
// Commit 88: 2025-02-27T16:54:05
// Commit 93: 2025-03-01T03:23:04
// Commit 94: 2025-03-01T10:43:02
// Commit 102: 2025-03-03T19:53:18
// Commit 105: 2025-03-04T17:02:32
// Commit 108: 2025-03-05T14:28:12
// Commit 112: 2025-03-06T18:00:12
// Commit 120: 2025-03-09T03:13:45
// Commit 122: 2025-03-09T16:43:57
// Commit 126: 2025-03-10T21:52:20
// Commit 128: 2025-03-11T11:48:55
// Commit 130: 2025-03-12T01:45:53
// Commit 133: 2025-03-12T22:40:16
// Commit 134: 2025-03-13T05:44:28
// Commit 137: 2025-03-14T03:15:28
// Commit 139: 2025-03-14T17:18:06
// Commit 140: 2025-03-15T00:29:45
// Commit 142: 2025-03-15T14:35:14
// Commit 143: 2025-03-15T22:18:56
// Commit 147: 2025-03-17T02:04:35
// Commit 149: 2025-03-17T16:47:48
// Commit 152: 2025-03-18T13:41:40
// Commit 153: 2025-03-18T20:27:26
// Commit 162: 2025-03-21T12:41:32
// Commit 163: 2025-03-21T19:46:11
// Commit 175: 2025-03-25T08:39:08
// Commit 188: 2025-03-29T04:32:23
// Commit 193: 2025-03-30T15:42:20
// Commit 194: 2025-03-30T22:55:57
// Commit 200: 2025-04-01T17:28:52
// Commit 5: 2025-02-03T04:49:55
// Commit 10: 2025-02-04T15:51:01
// Commit 15: 2025-02-06T03:26:49
// Commit 16: 2025-02-06T10:46:22
// Commit 17: 2025-02-06T17:52:50
// Commit 18: 2025-02-07T01:12:08
// Commit 20: 2025-02-07T14:51:25
// Commit 28: 2025-02-09T23:14:09
// Commit 38: 2025-02-12T22:06:01
// Commit 41: 2025-02-13T19:46:23
// Commit 42: 2025-02-14T02:26:41
// Commit 44: 2025-02-14T17:04:15
// Commit 53: 2025-02-17T08:48:05
// Commit 54: 2025-02-17T15:53:21
// Commit 59: 2025-02-19T02:43:20
// Commit 68: 2025-02-21T18:45:00
// Commit 72: 2025-02-22T23:28:21
// Commit 82: 2025-02-25T22:17:42
// Commit 85: 2025-02-26T19:12:01
// Commit 87: 2025-02-27T09:18:14
// Commit 90: 2025-02-28T07:04:25
// Commit 92: 2025-02-28T20:19:45
// Commit 94: 2025-03-01T10:50:04
// Commit 95: 2025-03-01T17:54:27
// Commit 98: 2025-03-02T15:41:42
// Commit 102: 2025-03-03T19:27:00
// Commit 105: 2025-03-04T16:33:59
// Commit 118: 2025-03-08T12:50:50
// Commit 127: 2025-03-11T04:27:12
// Commit 130: 2025-03-12T01:59:16
// Commit 139: 2025-03-14T17:10:27
// Commit 148: 2025-03-17T09:43:33
// Commit 157: 2025-03-20T01:04:54
// Commit 159: 2025-03-20T15:13:26
// Commit 161: 2025-03-21T05:08:30
// Commit 164: 2025-03-22T02:12:06
// Commit 165: 2025-03-22T09:45:51
// Commit 166: 2025-03-22T16:14:47
// Commit 172: 2025-03-24T11:08:07
// Commit 178: 2025-03-26T05:18:11
// Commit 185: 2025-03-28T07:06:45
// Commit 193: 2025-03-30T15:35:39
// Commit 194: 2025-03-30T22:51:25
// Commit 6: 2025-02-03T11:25:18
// Commit 9: 2025-02-04T09:32:43
// Commit 14: 2025-02-05T20:34:13
// Commit 15: 2025-02-06T03:59:27
// Commit 16: 2025-02-06T10:50:05
// Commit 20: 2025-02-07T14:49:03
// Commit 26: 2025-02-09T09:59:22
// Commit 35: 2025-02-12T00:58:18
// Commit 38: 2025-02-12T22:34:13
// Commit 40: 2025-02-13T12:14:52
// Commit 43: 2025-02-14T10:12:52
// Commit 45: 2025-02-14T23:33:10
// Commit 49: 2025-02-16T03:54:31
// Commit 52: 2025-02-17T01:52:14
// Commit 58: 2025-02-18T20:33:30
// Commit 61: 2025-02-19T17:35:15
// Commit 66: 2025-02-21T04:24:33
// Commit 79: 2025-02-25T00:31:59
// Commit 82: 2025-02-25T22:05:47
// Commit 86: 2025-02-27T02:46:27
// Commit 91: 2025-02-28T13:36:44
// Commit 92: 2025-02-28T21:06:58
// Commit 93: 2025-03-01T04:01:46
// Commit 95: 2025-03-01T18:08:27
// Commit 105: 2025-03-04T16:35:12
// Commit 106: 2025-03-05T00:12:34
// Commit 115: 2025-03-07T15:43:07
// Commit 119: 2025-03-08T19:56:18
// Commit 124: 2025-03-10T07:12:56
// Commit 134: 2025-03-13T06:05:49
// Commit 135: 2025-03-13T13:38:09
// Commit 138: 2025-03-14T10:43:31
// Commit 139: 2025-03-14T17:37:34
// Commit 141: 2025-03-15T07:34:00
// Commit 149: 2025-03-17T15:53:43
// Commit 157: 2025-03-20T00:43:04
// Commit 160: 2025-03-20T22:40:17
// Commit 162: 2025-03-21T12:11:29
// Commit 169: 2025-03-23T14:18:00
// Commit 174: 2025-03-25T01:16:57
// Commit 176: 2025-03-25T15:16:54
// Commit 180: 2025-03-26T20:03:31
// Commit 182: 2025-03-27T09:29:07
// Commit 185: 2025-03-28T07:00:15
// Commit 194: 2025-03-30T22:51:31
// Commit 200: 2025-04-01T17:06:08
// Commit 4: 2025-02-02T22:09:54
// Commit 5: 2025-02-03T04:41:37
// Commit 10: 2025-02-04T15:52:23
// Commit 17: 2025-02-06T18:06:43
// Commit 18: 2025-02-07T01:20:00
// Commit 21: 2025-02-07T21:55:30
// Commit 23: 2025-02-08T11:49:40
// Commit 32: 2025-02-11T03:58:36
// Commit 33: 2025-02-11T11:21:49
// Commit 35: 2025-02-12T01:27:43
// Commit 44: 2025-02-14T16:46:41
// Commit 47: 2025-02-15T14:08:05
// Commit 48: 2025-02-15T21:39:40
// Commit 55: 2025-02-17T22:37:48
// Commit 63: 2025-02-20T07:26:23
// Commit 67: 2025-02-21T11:19:56
// Commit 72: 2025-02-22T23:13:34
// Commit 75: 2025-02-23T20:21:55
// Commit 80: 2025-02-25T08:17:24
// Commit 85: 2025-02-26T18:56:16
// Commit 87: 2025-02-27T09:29:48
// Commit 90: 2025-02-28T06:18:29
// Commit 101: 2025-03-03T12:38:52
// Commit 104: 2025-03-04T09:55:17
// Commit 106: 2025-03-04T23:31:56
// Commit 108: 2025-03-05T13:59:43
// Commit 109: 2025-03-05T20:52:24
// Commit 113: 2025-03-07T01:27:33
// Commit 116: 2025-03-07T23:00:12
// Commit 117: 2025-03-08T05:50:40
// Commit 129: 2025-03-11T18:51:18
// Commit 132: 2025-03-12T15:50:21
// Commit 134: 2025-03-13T06:36:05
// Commit 146: 2025-03-16T19:33:40
// Commit 147: 2025-03-17T01:48:36
// Commit 152: 2025-03-18T13:07:55
// Commit 153: 2025-03-18T21:05:43
// Commit 154: 2025-03-19T04:03:26
// Commit 155: 2025-03-19T10:51:00
// Commit 157: 2025-03-20T00:38:24
// Commit 161: 2025-03-21T05:04:19
// Commit 163: 2025-03-21T19:20:19
