# FinanceArcade - Flutter Finance App

A comprehensive Flutter finance management app with an arcade-style dark theme UI.

## Features

### Core Features

-   **Dashboard** with total balance, income, expenses, budget widget, and target widget
-   **Transaction Management** - Add/Edit/Delete transactions (income/expense)
-   **Categories** - Food, Transport, Bills, etc. with custom category creation
-   **Transaction History** with search and filtering capabilities
-   **Analytics** - Simple analytics with pie charts and bar charts
-   **Local Storage** - Uses Hive for offline-first data storage

### Advanced Features

-   **Budget Planning** - Set monthly/weekly budgets per category with progress tracking and alerts
-   **Recurring Transactions** - Set up recurring (daily/weekly/monthly/yearly) expenses and income
-   **Multi-currency Support** - Select main currency and convert secondary currencies
-   **Custom Categories** - Create, edit, and delete custom categories
-   **Dark/Light Mode** - User-selectable theme with arcade-style dark mode
-   **Advanced Analytics** - Trends, bar/line charts, category/date filtering
-   **Search and Filter** - Search by note, category, amount, or date
-   **Dashboard Widgets** - Quick stats, active budgets, financial goals, and tips

## Architecture

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── transaction.dart
│   ├── category.dart
│   ├── budget.dart
│   └── financial_goal.dart
├── screens/                  # App screens
│   ├── main_screen.dart
│   ├── dashboard_screen.dart
│   └── placeholder_screens.dart
├── widgets/                  # Reusable UI components
│   ├── balance_card.dart
│   ├── quick_stats_card.dart
│   ├── recent_transactions_card.dart
│   ├── budget_progress_card.dart
│   └── expense_chart_card.dart
├── services/                 # Business logic and data services
│   ├── storage_service.dart
│   ├── theme_service.dart
│   ├── transaction_service.dart
│   ├── category_service.dart
│   └── budget_service.dart
├── themes/                   # Theme configurations
│   └── app_theme.dart
└── utils/                    # Utility functions
    └── app_utils.dart
```

## Theme

The app features an **arcade-style theme** with:

-   **Dark Mode** as the primary theme with neon colors (Cyan, Magenta, Green)
-   **Light Mode** with professional purple color scheme
-   **Google Fonts** - Orbitron for headings, Roboto for body text
-   **Smooth animations** and transitions
-   **Glowing effects** and shadows in dark mode

## Getting Started

### Prerequisites

1. Install Flutter SDK
2. Install VS Code with Flutter and Dart extensions
3. Set up an emulator or connect a physical device

### Installation

1. Clone the repository or open this folder in VS Code
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

### Building

```bash
# Get dependencies
flutter pub get

# Generate Hive adapters (if needed)
flutter packages pub run build_runner build

# Run the app
flutter run

# Build APK
flutter build apk
```

## Development Notes

-   **Offline-first**: All data is stored locally using Hive
-   **State Management**: Uses Provider for reactive state management
-   **Responsive Design**: Adapts to different screen sizes
-   **Material Design 3**: Uses the latest Material Design components

## Color Palette

### Dark Theme (Arcade Style)

-   Primary Neon: `#00FFFF` (Cyan)
-   Secondary Neon: `#FF00FF` (Magenta)
-   Accent Neon: `#00FF00` (Green)
-   Background: `#0A0A0F`

### Light Theme

-   Primary: Deep Purple
-   Background: `#F5F5F7`

## License

This project is created for educational and portfolio purposes.

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

-   [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
-   [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Update 2025-02-03T11:45:03 [6]

Update 2025-02-04T02:04:21 [8]

Update 2025-02-06T10:37:05 [16]

Update 2025-02-08T12:22:37 [23]

Update 2025-02-09T16:46:35 [27]

Update 2025-02-12T08:37:11 [36]

Update 2025-02-19T10:37:28 [60]

Update 2025-02-21T05:05:22 [66]

Update 2025-02-21T11:28:07 [67]

Update 2025-02-25T15:10:02 [81]

Update 2025-02-25T22:26:29 [82]

Update 2025-02-28T07:03:48 [90]

Update 2025-03-16T04:42:55 [144]

Update 2025-03-19T03:16:57 [154]

Update 2025-03-30T01:47:27 [191]

Update 2025-04-01T02:58:13 [198]

Update 2025-02-04T16:25:40 

Update 2025-02-07T21:49:02 

Update 2025-02-08T12:04:17 

Update 2025-02-12T00:58:16 

Update 2025-02-15T21:42:36 

Update 2025-02-17T15:48:39 

Update 2025-02-18T05:49:23 

Update 2025-02-21T04:59:16 

Update 2025-02-24T03:39:45 

Update 2025-02-26T11:47:03 

Update 2025-03-01T18:28:07 

Update 2025-03-03T12:20:48 

Update 2025-03-05T00:04:27 

Update 2025-03-08T05:52:15 

Update 2025-03-16T05:23:53 

Update 2025-03-19T04:08:55 

Update 2025-03-20T15:12:46 

Update 2025-03-21T19:51:09 

Update 2025-03-26T05:54:03 

Update 2025-03-26T19:42:27 

Update 2025-04-01T09:56:23 

Update 2025-02-02T07:29:01 

Update 2025-02-03T11:42:06 

Update 2025-02-04T16:06:39 

Update 2025-02-06T03:23:40 

Update 2025-02-06T10:44:50 

Update 2025-02-06T17:58:50 

Update 2025-02-07T07:33:36 

Update 2025-02-08T04:43:09 

Update 2025-02-08T12:37:50 

Update 2025-02-09T16:12:42 

Update 2025-02-09T23:48:50 

Update 2025-02-10T06:22:56 

Update 2025-02-10T21:17:27 

Update 2025-02-11T11:12:02 

Update 2025-02-11T17:59:56 

Update 2025-02-12T07:50:20 

Update 2025-02-12T15:29:18 

Update 2025-02-13T05:42:56 

Update 2025-02-13T19:25:18 

Update 2025-02-14T10:16:12 

Update 2025-02-16T18:28:28 

Update 2025-02-17T01:28:02 

Update 2025-02-17T08:46:31 

Update 2025-02-17T15:55:52 

Update 2025-02-18T05:29:45 

Update 2025-02-18T20:07:00 

Update 2025-02-19T10:14:31 

Update 2025-02-20T00:23:51 

Update 2025-02-20T07:21:05 

Update 2025-02-20T14:50:57 

Update 2025-02-20T21:14:29 

Update 2025-02-21T04:51:54 

Update 2025-02-21T12:07:26 

Update 2025-02-22T23:15:26 

Update 2025-02-23T06:27:02 

Update 2025-02-23T20:00:54 

Update 2025-02-25T01:10:33 

Update 2025-02-25T08:10:29 

Update 2025-02-26T19:31:51 

Update 2025-02-27T02:30:19 

Update 2025-02-27T08:54:07 

Update 2025-02-27T23:12:28 

Update 2025-02-28T13:34:03 

Update 2025-02-28T20:43:10 

Update 2025-03-01T17:34:36 

Update 2025-03-02T01:16:34 

Update 2025-03-02T08:27:38 

Update 2025-03-03T12:19:11 

Update 2025-03-03T19:58:20 

Update 2025-03-04T16:34:37 

Update 2025-03-05T00:21:48 

Update 2025-03-07T15:29:04 

Update 2025-03-07T23:02:58 

Update 2025-03-08T05:43:03 

Update 2025-03-08T19:31:03 

Update 2025-03-09T09:56:12 

Update 2025-03-09T16:49:05 

Update 2025-03-09T23:54:24 

Update 2025-03-10T14:45:57 

Update 2025-03-10T21:29:55 

Update 2025-03-11T04:07:55 

Update 2025-03-12T08:37:49 

Update 2025-03-12T15:32:53 

Update 2025-03-13T13:30:09 

Update 2025-03-13T20:06:16 

Update 2025-03-15T00:10:46 

Update 2025-03-16T05:08:24 

Update 2025-03-16T19:11:22 

Update 2025-03-18T06:51:41 

Update 2025-03-18T13:43:43 

Update 2025-03-18T20:40:10 

Update 2025-03-19T03:41:28 

Update 2025-03-20T00:54:47 

Update 2025-03-21T05:16:22 

Update 2025-03-21T12:36:12 

Update 2025-03-21T19:29:51 

Update 2025-03-22T02:28:09 

Update 2025-03-22T16:58:56 

Update 2025-03-23T20:53:12 

Update 2025-03-24T04:14:07 

Update 2025-03-24T11:34:37 

Update 2025-03-25T01:04:12 

Update 2025-03-25T08:43:38 

Update 2025-03-25T15:46:22 

Update 2025-03-25T22:49:11 

Update 2025-03-26T05:40:56 

Update 2025-03-27T02:51:44 

Update 2025-03-27T09:48:02 

Update 2025-03-27T16:55:06 

Update 2025-03-28T07:03:45 

Update 2025-03-28T21:38:08 

Update 2025-03-29T04:03:36 

Update 2025-03-30T08:27:54 

Update 2025-03-30T22:43:01 

Update 2025-04-01T03:44:57 

Update 2025-04-01T10:46:28 

Update 2025-02-02T00:23:35 

Update 2025-02-02T07:39:51 

Update 2025-02-02T15:03:35 

Update 2025-02-03T11:33:14 

Update 2025-02-03T18:41:03 

Update 2025-02-04T15:59:51 

Update 2025-02-05T06:36:23 

Update 2025-02-06T11:04:48 

Update 2025-02-06T18:13:22 

Update 2025-02-07T00:29:01 

Update 2025-02-08T12:28:02 

Update 2025-02-09T02:55:07 

Update 2025-02-10T13:52:31 

Update 2025-02-10T20:30:21 

Update 2025-02-11T18:37:01 

Update 2025-02-12T00:55:02 

Update 2025-02-12T08:01:32 

Update 2025-02-12T15:14:11 

Update 2025-02-12T22:56:15 

Update 2025-02-13T05:28:38 

Update 2025-02-13T19:12:52 

Update 2025-02-14T02:58:25 

Update 2025-02-14T09:34:18 

Update 2025-02-14T23:35:04 

Update 2025-02-15T13:40:49 

Update 2025-02-17T08:13:40 

Update 2025-02-19T03:25:48 

Update 2025-02-20T00:08:00 

Update 2025-02-20T14:43:16 

Update 2025-02-20T21:10:39 

Update 2025-02-21T04:58:28 

Update 2025-02-22T01:56:49 

Update 2025-02-22T15:52:31 

Update 2025-02-23T06:07:34 

Update 2025-02-23T20:49:30 

Update 2025-02-24T10:28:37 

Update 2025-02-25T14:36:32 

Update 2025-02-25T22:06:36 

Update 2025-02-27T02:01:23 

Update 2025-02-27T23:58:58 

Update 2025-02-28T06:57:25 

Update 2025-03-01T10:43:02 

Update 2025-03-02T08:24:32 

Update 2025-03-02T15:33:04 

Update 2025-03-03T04:59:48 

Update 2025-03-03T12:45:29 

Update 2025-03-04T02:13:19 

Update 2025-03-04T09:54:04 

Update 2025-03-04T17:02:32 

Update 2025-03-04T23:28:54 

Update 2025-03-06T04:36:51 

Update 2025-03-06T18:00:12 

Update 2025-03-07T08:22:41 

Update 2025-03-07T22:25:48 

Update 2025-03-08T06:13:26 

Update 2025-03-09T10:00:41 

Update 2025-03-10T00:14:50 

Update 2025-03-10T07:14:53 

Update 2025-03-10T14:41:13 

Update 2025-03-10T21:52:20 

Update 2025-03-11T05:03:29 

Update 2025-03-11T18:39:38 

Update 2025-03-12T01:45:53 

Update 2025-03-12T16:18:03 

Update 2025-03-12T22:40:16 

Update 2025-03-14T17:18:06 

Update 2025-03-15T22:18:56 

Update 2025-03-16T18:55:12 

Update 2025-03-17T02:04:35 

Update 2025-03-17T23:45:32 

Update 2025-03-18T06:13:17 

Update 2025-03-19T10:55:29 

Update 2025-03-20T00:48:15 

Update 2025-03-20T14:44:44 

Update 2025-03-20T22:37:58 

Update 2025-03-21T05:32:24 

Update 2025-03-21T19:46:11 

Update 2025-03-23T14:02:27 

Update 2025-03-24T04:04:37 

Update 2025-03-24T18:07:15 

Update 2025-03-25T01:32:23 

Update 2025-03-25T08:39:08 

Update 2025-03-26T05:43:07 

Update 2025-03-26T12:58:50 

Update 2025-03-26T20:11:38 

Update 2025-03-27T23:52:51 

Update 2025-03-28T13:55:03 

Update 2025-03-28T21:47:18 

Update 2025-03-29T04:32:23 

Update 2025-03-29T11:04:54 

Update 2025-03-31T05:43:16 

Update 2025-03-31T13:31:06 

Update 2025-04-01T02:57:44 

Update 2025-02-02T00:35:43 

Update 2025-02-02T21:39:16 

Update 2025-02-03T04:49:55 

Update 2025-02-04T01:43:46 

Update 2025-02-04T09:01:44 

Update 2025-02-04T23:03:55 

Update 2025-02-06T10:46:22 

Update 2025-02-07T01:12:08 

Update 2025-02-07T14:51:25 

Update 2025-02-08T04:57:23 

Update 2025-02-08T11:46:23 

Update 2025-02-08T19:31:30 

Update 2025-02-09T09:54:24 

Update 2025-02-09T16:28:40 

Update 2025-02-09T23:14:09 

Update 2025-02-10T06:33:55 

Update 2025-02-10T13:31:39 

Update 2025-02-10T21:01:45 

Update 2025-02-11T10:52:35 

Update 2025-02-12T08:12:27 

Update 2025-02-13T05:52:02 

Update 2025-02-13T19:46:23 

Update 2025-02-14T17:04:15 

Update 2025-02-15T14:07:46 

Update 2025-02-16T04:40:21 

Update 2025-02-16T11:17:59 

Update 2025-02-17T01:47:35 

Update 2025-02-17T08:48:05 

Update 2025-02-17T15:53:21 

Update 2025-02-17T23:11:55 

Update 2025-02-18T05:51:06 

Update 2025-02-18T13:27:51 

Update 2025-02-19T02:43:20 

Update 2025-02-19T17:45:55 

Update 2025-02-20T00:48:33 

Update 2025-02-20T07:22:18 

Update 2025-02-21T05:00:54 

Update 2025-02-21T11:55:23 

Update 2025-02-22T01:54:44 

Update 2025-02-22T16:14:52 

Update 2025-02-23T20:26:46 

Update 2025-02-24T10:38:50 

Update 2025-02-24T17:58:14 

Update 2025-02-25T00:45:06 

Update 2025-02-25T07:41:50 

Update 2025-02-25T22:17:42 

Update 2025-02-26T12:22:49 

Update 2025-02-27T02:28:32 

Update 2025-02-27T16:18:42 

Update 2025-02-27T23:38:15 

Update 2025-02-28T20:19:45 

Update 2025-03-01T04:06:24 

Update 2025-03-02T00:58:24 

Update 2025-03-03T05:35:30 

Update 2025-03-04T09:35:35 

Update 2025-03-05T07:12:39 

Update 2025-03-05T13:57:54 

Update 2025-03-06T04:37:56 

Update 2025-03-07T01:35:14 

Update 2025-03-08T05:59:39 

Update 2025-03-09T10:30:16 

Update 2025-03-10T00:37:37 

Update 2025-03-10T21:48:50 

Update 2025-03-11T18:29:32 

Update 2025-03-12T23:12:39 

Update 2025-03-13T05:56:18 

Update 2025-03-13T20:31:45 

Update 2025-03-14T03:20:11 

Update 2025-03-14T10:35:57 

Update 2025-03-14T17:10:27 

Update 2025-03-15T00:43:34 

Update 2025-03-15T08:06:29 

Update 2025-03-15T14:19:49 

Update 2025-03-16T11:39:48 

Update 2025-03-17T02:18:08 

Update 2025-03-17T09:43:33 

Update 2025-03-17T23:26:40 

Update 2025-03-18T06:34:57 

Update 2025-03-18T20:58:34 

Update 2025-03-19T03:25:45 

Update 2025-03-19T10:54:15 

Update 2025-03-19T17:54:45 

Update 2025-03-20T15:13:26 

Update 2025-03-20T21:57:28 

Update 2025-03-22T02:12:06 

Update 2025-03-22T09:45:51 

Update 2025-03-22T16:14:47 

Update 2025-03-23T00:03:24 

Update 2025-03-23T21:20:38 

Update 2025-03-24T04:30:03 

Update 2025-03-25T01:38:31 

Update 2025-03-25T08:53:26 

Update 2025-03-26T12:44:22 

Update 2025-03-26T20:03:05 

Update 2025-03-27T03:08:41 

Update 2025-03-27T09:45:15 

Update 2025-03-28T00:20:05 

Update 2025-03-28T07:06:45 

Update 2025-03-29T04:24:09 

Update 2025-03-29T18:42:00 

Update 2025-03-30T08:58:50 

Update 2025-03-30T22:51:25 

Update 2025-03-31T05:36:04 

Update 2025-03-31T19:53:20 

Update 2025-04-01T10:24:52 

Update 2025-04-01T17:40:47 

Update 2025-02-02T07:27:47 

Update 2025-02-03T11:25:18 

Update 2025-02-04T01:58:59 

Update 2025-02-04T23:35:52 

Update 2025-02-05T13:49:44 

Update 2025-02-05T20:34:13 

Update 2025-02-06T10:50:05 

Update 2025-02-07T00:42:18 

Update 2025-02-07T08:03:37 

Update 2025-02-07T14:49:03 

Update 2025-02-07T22:06:38 

Update 2025-02-08T05:09:18 

Update 2025-02-08T12:26:21 

Update 2025-02-09T02:50:10 

Update 2025-02-09T16:25:05 

Update 2025-02-10T06:58:15 

Update 2025-02-10T13:21:46 

Update 2025-02-11T11:21:02 

Update 2025-02-12T00:58:18 

Update 2025-02-12T08:16:51 

Update 2025-02-12T14:55:58 

Update 2025-02-12T22:34:13 

Update 2025-02-13T20:06:22 

Update 2025-02-14T03:13:10 

Update 2025-02-14T17:14:04 

Update 2025-02-15T14:13:46 

Update 2025-02-15T21:26:43 

Update 2025-02-19T03:14:47 

Update 2025-02-19T10:34:22 

Update 2025-02-20T21:26:35 

Update 2025-02-21T04:24:33 

Update 2025-02-21T18:35:52 

Update 2025-02-22T01:28:47 

Update 2025-02-22T08:48:01 

Update 2025-02-22T23:08:29 

Update 2025-02-24T03:46:59 

Update 2025-02-24T11:01:09 

Update 2025-02-25T00:31:59 

Update 2025-02-25T08:11:57 

Update 2025-02-26T04:49:57 

Update 2025-02-26T12:06:20 

Update 2025-02-26T18:56:11 

Update 2025-02-27T02:46:27 

Update 2025-02-27T16:00:14 

Update 2025-02-27T23:53:41 

Update 2025-02-28T07:00:25 

Update 2025-02-28T21:06:58 

Update 2025-03-01T18:08:27 

Update 2025-03-02T01:31:43 

Update 2025-03-02T08:32:38 

Update 2025-03-03T05:54:44 

Update 2025-03-03T12:32:27 

Update 2025-03-04T02:15:11 

Update 2025-03-05T00:12:34 

Update 2025-03-05T06:54:22 

Update 2025-03-05T13:42:48 

Update 2025-03-05T20:57:23 

Update 2025-03-06T04:00:00 

Update 2025-03-06T18:07:37 

Update 2025-03-08T06:02:53 

Update 2025-03-09T03:06:47 

Update 2025-03-10T14:35:42 

Update 2025-03-10T21:30:47 

Update 2025-03-11T18:49:47 

Update 2025-03-13T06:05:49 

Update 2025-03-13T13:38:09 

Update 2025-03-13T20:06:37 

Update 2025-03-15T14:38:52 

Update 2025-03-15T21:53:50 

Update 2025-03-16T18:49:28 

Update 2025-03-17T02:04:42 

Update 2025-03-17T23:25:45 

Update 2025-03-18T06:26:30 

Update 2025-03-18T13:42:14 

Update 2025-03-18T20:44:31 

Update 2025-03-19T03:22:27 

Update 2025-03-19T10:32:11 

Update 2025-03-20T07:35:49 

Update 2025-03-20T15:05:27 

Update 2025-03-21T05:43:10 

Update 2025-03-22T02:22:58 

Update 2025-03-22T16:24:47 

Update 2025-03-23T07:16:15 

Update 2025-03-23T14:18:00 

Update 2025-03-23T20:51:14 

Update 2025-03-24T04:20:09 

Update 2025-03-24T18:43:00 

Update 2025-03-26T05:47:00 

Update 2025-03-26T13:01:44 

Update 2025-03-27T16:54:31 

Update 2025-03-28T21:05:24 

Update 2025-03-29T04:13:18 

Update 2025-03-29T19:00:54 

Update 2025-03-30T16:21:15 

Update 2025-03-31T05:34:15 

Update 2025-02-02T00:44:16 

Update 2025-02-02T07:32:05 

Update 2025-02-02T22:09:54 

Update 2025-02-03T04:41:37 

Update 2025-02-04T15:52:23 

Update 2025-02-05T06:41:33 

Update 2025-02-05T13:50:13 

Update 2025-02-05T20:34:13 

Update 2025-02-07T15:13:00 

Update 2025-02-08T04:56:25 

Update 2025-02-08T11:49:40 

Update 2025-02-09T09:28:50 

Update 2025-02-09T23:30:43 

Update 2025-02-10T13:21:35 

Update 2025-02-12T08:46:50 

Update 2025-02-12T15:48:49 

Update 2025-02-12T22:33:18 

Update 2025-02-13T12:31:38 

Update 2025-02-14T09:44:28 

Update 2025-02-15T00:19:14 

Update 2025-02-15T14:08:05 

Update 2025-02-16T18:32:59 

Update 2025-02-17T01:11:57 

Update 2025-02-17T09:09:23 

Update 2025-02-18T06:21:56 

Update 2025-02-18T20:06:21 

Update 2025-02-19T10:34:50 

Update 2025-02-19T16:55:45 

Update 2025-02-20T21:44:44 

Update 2025-02-21T11:19:56 

Update 2025-02-21T18:23:06 

Update 2025-02-22T02:21:26 

Update 2025-02-22T08:54:46 

Update 2025-02-22T23:13:34 

Update 2025-02-23T20:21:55 

Update 2025-02-25T01:09:11 

Update 2025-02-25T21:45:01 

Update 2025-02-26T05:10:36 

Update 2025-02-27T02:35:02 

Update 2025-02-27T16:21:39 

Update 2025-02-28T13:28:52 

Update 2025-03-01T10:31:52 

Update 2025-03-03T12:38:52 

Update 2025-03-04T02:58:18 

Update 2025-03-04T17:13:23 

Update 2025-03-05T06:58:04 

Update 2025-03-05T20:52:24 

Update 2025-03-06T03:53:47 

Update 2025-03-06T11:39:37 

Update 2025-03-06T18:00:59 

Update 2025-03-07T01:27:33 

Update 2025-03-07T08:44:50 

Update 2025-03-07T23:00:12 

Update 2025-03-09T02:56:04 

Update 2025-03-10T00:22:55 

Update 2025-03-10T07:13:03 

Update 2025-03-10T14:02:47 

Update 2025-03-11T11:25:26 

Update 2025-03-11T18:51:18 

Update 2025-03-12T01:37:42 

Update 2025-03-12T08:47:02 

Update 2025-03-12T23:28:06 

Update 2025-03-13T06:36:05 

Update 2025-03-13T20:05:31 

Update 2025-03-14T10:05:55 

Update 2025-03-14T17:05:28 

Update 2025-03-15T07:51:11 

Update 2025-03-16T04:42:01 

Update 2025-03-16T12:23:23 

Update 2025-03-17T08:52:35 

Update 2025-03-17T23:26:43 

Update 2025-03-18T06:25:49 

Update 2025-03-18T13:07:55 

Update 2025-03-19T10:51:00 

Update 2025-03-19T17:46:17 

Update 2025-03-20T07:57:17 

Update 2025-03-20T22:22:13 

Update 2025-03-21T11:53:55 

Update 2025-03-22T02:28:55 

Update 2025-03-23T07:11:13 

Update 2025-03-23T13:55:46 

Update 2025-03-24T04:03:51 

Update 2025-03-25T01:03:02 

Update 2025-03-25T15:21:07 

Update 2025-03-26T05:34:37 

Update 2025-03-26T20:18:50 

Update 2025-03-27T09:36:33 

Update 2025-03-27T17:26:29 

Update 2025-03-28T00:01:13 

Update 2025-03-28T14:14:57 

Update 2025-03-28T21:17:31 

Update 2025-03-30T01:23:56 

Update 2025-03-30T22:41:47 

Update 2025-03-31T06:28:59 

Update 2025-03-31T12:40:51 

Update 2025-04-01T02:47:03 

Update 2025-04-01T09:59:03 
