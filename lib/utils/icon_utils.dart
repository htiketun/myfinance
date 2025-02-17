import 'package:flutter/material.dart';

/// FinanceArcade Icon Utilities - Tree-shake friendly icon management
class IconUtils {
  /// Map of icon names to their constant IconData for safe usage
  static const Map<String, IconData> iconMap = {
    // Food & Dining
    'restaurant': Icons.restaurant,
    'local_cafe': Icons.local_cafe,
    'fastfood': Icons.fastfood,

    // Transportation
    'directions_car': Icons.directions_car,
    'local_gas_station': Icons.local_gas_station,
    'train': Icons.train,
    'flight': Icons.flight,
    'directions_bus': Icons.directions_bus,

    // Shopping
    'shopping_bag': Icons.shopping_bag,
    'shopping_cart': Icons.shopping_cart,
    'store': Icons.store,

    // Entertainment
    'movie': Icons.movie,
    'music_note': Icons.music_note,
    'gamepad': Icons.gamepad,

    // Utilities
    'receipt': Icons.receipt,
    'power': Icons.power,
    'water_drop': Icons.water_drop,
    'wifi': Icons.wifi,
    'phone': Icons.phone,

    // Health
    'local_hospital': Icons.local_hospital,
    'spa': Icons.spa,
    'fitness_center': Icons.fitness_center,

    // Work
    'work': Icons.work,
    'business': Icons.business,
    'laptop': Icons.laptop,
    'trending_up': Icons.trending_up,
    'account_balance': Icons.account_balance,

    // Home
    'home': Icons.home,
    'apartment': Icons.apartment,

    // Education
    'school': Icons.school,
    'book': Icons.book,

    // Gifts
    'card_giftcard': Icons.card_giftcard,
    'celebration': Icons.celebration,
  };

  /// Get IconData by code point safely
  static IconData getIconByCodePoint(int codePoint) {
    // Find matching icon in our predefined set
    for (final icon in iconMap.values) {
      if (icon.codePoint == codePoint) {
        return icon;
      }
    }

    // Return safe fallback
    return Icons.category;
  }

  /// Get IconData by name safely
  static IconData getIconByName(String name) {
    return iconMap[name] ?? Icons.category;
  }

  /// Get all available icons as a list
  static List<IconData> get allIcons => iconMap.values.toList();

  /// Get icon code point safely
  static int getCodePoint(IconData icon) {
    return icon.codePoint;
  }
}
// Commit 26: 2025-02-09T09:41:19
// Commit 32: 2025-02-11T03:40:04
// Commit 35: 2025-02-12T01:23:15
// Commit 40: 2025-02-13T12:36:21
// Commit 61: 2025-02-19T17:00:15
// Commit 62: 2025-02-20T00:45:09
// Commit 70: 2025-02-22T08:36:19
// Commit 91: 2025-02-28T13:58:36
// Commit 122: 2025-03-09T17:40:03
// Commit 130: 2025-03-12T01:29:53
// Commit 146: 2025-03-16T19:03:58
// Commit 155: 2025-03-19T10:52:46
// Commit 157: 2025-03-20T01:04:15
// Commit 159: 2025-03-20T14:56:21
// Commit 167: 2025-03-22T23:24:57
// Commit 178: 2025-03-26T05:15:38
// Commit 184: 2025-03-27T23:41:35
// Commit 187: 2025-03-28T21:20:51
// Commit 197: 2025-03-31T20:10:01
// Commit 199: 2025-04-01T10:26:52
// Commit 15: 2025-02-06T03:50:50
// Commit 27: 2025-02-09T16:24:40
// Commit 49: 2025-02-16T04:11:15
// Commit 78: 2025-02-24T17:25:36
// Commit 82: 2025-02-25T21:32:30
// Commit 83: 2025-02-26T05:13:21
// Commit 87: 2025-02-27T09:00:39
// Commit 105: 2025-03-04T17:18:29
// Commit 118: 2025-03-08T12:27:54
// Commit 138: 2025-03-14T10:18:50
// Commit 142: 2025-03-15T14:31:59
// Commit 1: 2025-02-02T00:41:21
// Commit 3: 2025-02-02T14:22:03
// Commit 11: 2025-02-04T22:49:25
// Commit 14: 2025-02-05T20:40:21
// Commit 18: 2025-02-07T00:37:57
// Commit 19: 2025-02-07T07:33:36
// Commit 22: 2025-02-08T04:43:09
// Commit 34: 2025-02-11T17:59:56
// Commit 35: 2025-02-12T01:40:36
// Commit 39: 2025-02-13T05:42:56
// Commit 45: 2025-02-15T00:10:26
// Commit 49: 2025-02-16T04:42:04
// Commit 53: 2025-02-17T08:46:31
// Commit 54: 2025-02-17T15:55:52
// Commit 61: 2025-02-19T17:05:50
// Commit 75: 2025-02-23T20:00:54
// Commit 78: 2025-02-24T17:18:28
// Commit 87: 2025-02-27T08:54:07
// Commit 88: 2025-02-27T16:06:28
// Commit 92: 2025-02-28T20:43:10
// Commit 97: 2025-03-02T08:27:38
// Commit 99: 2025-03-02T21:50:27
// Commit 100: 2025-03-03T05:23:38
// Commit 105: 2025-03-04T16:34:37
// Commit 109: 2025-03-05T21:21:56
// Commit 113: 2025-03-07T01:54:50
// Commit 118: 2025-03-08T12:57:56
// Commit 120: 2025-03-09T02:39:01
// Commit 121: 2025-03-09T09:56:12
// Commit 132: 2025-03-12T15:32:53
// Commit 137: 2025-03-14T03:21:12
// Commit 143: 2025-03-15T21:25:05
// Commit 145: 2025-03-16T11:44:41
// Commit 146: 2025-03-16T19:11:22
// Commit 148: 2025-03-17T09:18:21
// Commit 149: 2025-03-17T16:07:15
// Commit 160: 2025-03-20T22:10:52
// Commit 161: 2025-03-21T05:16:22
// Commit 165: 2025-03-22T09:32:17
// Commit 166: 2025-03-22T16:58:56
// Commit 167: 2025-03-22T23:28:20
// Commit 174: 2025-03-25T01:04:12
// Commit 176: 2025-03-25T15:46:22
// Commit 178: 2025-03-26T05:40:56
// Commit 179: 2025-03-26T13:08:08
// Commit 181: 2025-03-27T02:51:44
// Commit 190: 2025-03-29T18:08:19
// Commit 193: 2025-03-30T16:02:07
// Commit 5: 2025-02-03T04:30:31
// Commit 6: 2025-02-03T11:33:14
// Commit 8: 2025-02-04T01:53:48
// Commit 9: 2025-02-04T08:53:44
// Commit 13: 2025-02-05T13:23:18
// Commit 16: 2025-02-06T11:04:48
// Commit 19: 2025-02-07T07:58:33
// Commit 22: 2025-02-08T05:40:26
// Commit 27: 2025-02-09T16:29:34
// Commit 29: 2025-02-10T06:45:53
// Commit 30: 2025-02-10T13:52:31
// Commit 37: 2025-02-12T15:14:11
// Commit 41: 2025-02-13T19:12:52
// Commit 45: 2025-02-14T23:35:04
// Commit 48: 2025-02-15T21:21:15
// Commit 49: 2025-02-16T04:22:16
// Commit 56: 2025-02-18T06:10:29
// Commit 67: 2025-02-21T11:51:47
// Commit 70: 2025-02-22T08:57:21
// Commit 74: 2025-02-23T12:57:22
// Commit 85: 2025-02-26T19:04:09
// Commit 92: 2025-02-28T20:32:11
// Commit 99: 2025-03-02T22:37:04
// Commit 100: 2025-03-03T04:59:48
// Commit 101: 2025-03-03T12:45:29
// Commit 106: 2025-03-04T23:28:54
// Commit 115: 2025-03-07T15:17:53
// Commit 116: 2025-03-07T22:25:48
// Commit 118: 2025-03-08T12:38:07
// Commit 119: 2025-03-08T20:11:26
// Commit 124: 2025-03-10T07:14:53
// Commit 125: 2025-03-10T14:41:13
// Commit 129: 2025-03-11T18:39:38
// Commit 141: 2025-03-15T07:40:38
// Commit 144: 2025-03-16T04:31:40
// Commit 146: 2025-03-16T18:55:12
// Commit 151: 2025-03-18T06:13:17
// Commit 155: 2025-03-19T10:55:29
// Commit 158: 2025-03-20T08:11:54
// Commit 160: 2025-03-20T22:37:58
// Commit 161: 2025-03-21T05:32:24
// Commit 166: 2025-03-22T16:49:37
// Commit 170: 2025-03-23T21:05:30
// Commit 172: 2025-03-24T10:52:20
// Commit 177: 2025-03-25T22:12:51
// Commit 180: 2025-03-26T20:11:38
// Commit 182: 2025-03-27T10:01:12
// Commit 191: 2025-03-30T02:10:08
// Commit 195: 2025-03-31T05:43:16
// Commit 4: 2025-02-02T21:39:16
// Commit 6: 2025-02-03T11:59:30
// Commit 8: 2025-02-04T01:43:46
// Commit 11: 2025-02-04T23:03:55
// Commit 12: 2025-02-05T06:04:06
// Commit 13: 2025-02-05T13:45:29
// Commit 14: 2025-02-05T20:55:29
// Commit 22: 2025-02-08T04:57:23
// Commit 27: 2025-02-09T16:28:40
// Commit 30: 2025-02-10T13:31:39
// Commit 33: 2025-02-11T10:52:35
// Commit 34: 2025-02-11T18:30:04
// Commit 37: 2025-02-12T15:16:28
// Commit 39: 2025-02-13T05:52:02
// Commit 45: 2025-02-14T23:37:37
// Commit 46: 2025-02-15T06:51:30
// Commit 47: 2025-02-15T14:07:46
// Commit 56: 2025-02-18T05:51:06
// Commit 57: 2025-02-18T13:27:51
// Commit 63: 2025-02-20T07:22:18
// Commit 65: 2025-02-20T21:12:05
// Commit 66: 2025-02-21T05:00:54
// Commit 73: 2025-02-23T06:33:19
// Commit 74: 2025-02-23T13:10:40
// Commit 77: 2025-02-24T10:38:50
// Commit 79: 2025-02-25T00:45:06
// Commit 80: 2025-02-25T07:41:50
// Commit 84: 2025-02-26T12:22:49
// Commit 86: 2025-02-27T02:28:32
// Commit 96: 2025-03-02T00:58:24
// Commit 97: 2025-03-02T08:21:04
// Commit 99: 2025-03-02T22:49:28
// Commit 101: 2025-03-03T12:45:33
// Commit 104: 2025-03-04T09:35:35
// Commit 107: 2025-03-05T07:12:39
// Commit 109: 2025-03-05T20:58:26
// Commit 111: 2025-03-06T11:10:29
// Commit 116: 2025-03-07T23:05:15
// Commit 119: 2025-03-08T19:38:26
// Commit 121: 2025-03-09T10:30:16
// Commit 132: 2025-03-12T15:32:45
// Commit 133: 2025-03-12T23:12:39
// Commit 135: 2025-03-13T13:13:33
// Commit 140: 2025-03-15T00:43:34
// Commit 142: 2025-03-15T14:19:49
// Commit 149: 2025-03-17T16:38:31
// Commit 150: 2025-03-17T23:26:40
// Commit 167: 2025-03-23T00:03:24
// Commit 169: 2025-03-23T14:24:58
// Commit 173: 2025-03-24T17:51:11
// Commit 174: 2025-03-25T01:38:31
// Commit 175: 2025-03-25T08:53:26
// Commit 176: 2025-03-25T15:33:52
// Commit 177: 2025-03-25T22:44:16
// Commit 186: 2025-03-28T14:39:59
// Commit 189: 2025-03-29T11:49:35
// Commit 196: 2025-03-31T12:56:07
// Commit 3: 2025-02-02T15:00:07
// Commit 7: 2025-02-03T19:26:33
// Commit 12: 2025-02-05T06:12:37
// Commit 22: 2025-02-08T05:09:18
// Commit 24: 2025-02-08T19:16:27
// Commit 25: 2025-02-09T02:50:10
// Commit 39: 2025-02-13T05:20:58
// Commit 42: 2025-02-14T03:13:10
// Commit 48: 2025-02-15T21:26:43
// Commit 51: 2025-02-16T18:14:52
// Commit 53: 2025-02-17T08:42:18
// Commit 54: 2025-02-17T15:58:35
// Commit 57: 2025-02-18T13:20:31
// Commit 65: 2025-02-20T21:26:35
// Commit 69: 2025-02-22T01:28:47
// Commit 70: 2025-02-22T08:48:01
// Commit 73: 2025-02-23T06:24:19
// Commit 74: 2025-02-23T12:54:18
// Commit 75: 2025-02-23T20:45:05
// Commit 78: 2025-02-24T17:16:35
// Commit 80: 2025-02-25T08:11:57
// Commit 83: 2025-02-26T04:49:57
// Commit 84: 2025-02-26T12:06:20
// Commit 89: 2025-02-27T23:53:41
// Commit 90: 2025-02-28T07:00:25
// Commit 99: 2025-03-02T22:10:18
// Commit 104: 2025-03-04T10:06:32
// Commit 107: 2025-03-05T06:54:22
// Commit 112: 2025-03-06T18:07:37
// Commit 118: 2025-03-08T13:20:10
// Commit 126: 2025-03-10T21:30:47
// Commit 131: 2025-03-12T08:49:18
// Commit 147: 2025-03-17T02:04:42
// Commit 153: 2025-03-18T20:44:31
// Commit 156: 2025-03-19T18:20:16
// Commit 158: 2025-03-20T07:35:49
// Commit 186: 2025-03-28T14:40:54
// Commit 187: 2025-03-28T21:05:24
// Commit 188: 2025-03-29T04:13:18
// Commit 190: 2025-03-29T19:00:54
// Commit 196: 2025-03-31T12:47:27
// Commit 198: 2025-04-01T03:23:27
// Commit 3: 2025-02-02T14:53:29
// Commit 6: 2025-02-03T11:40:25
// Commit 8: 2025-02-04T02:24:31
// Commit 11: 2025-02-04T23:07:22
// Commit 16: 2025-02-06T10:38:27
// Commit 26: 2025-02-09T09:28:50
// Commit 27: 2025-02-09T16:49:54
// Commit 28: 2025-02-09T23:30:43
// Commit 34: 2025-02-11T17:53:38
// Commit 40: 2025-02-13T12:31:38
// Commit 41: 2025-02-13T19:39:27
// Commit 50: 2025-02-16T11:47:59
// Commit 53: 2025-02-17T09:09:23
