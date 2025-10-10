// This is a basic Flutter widget test for FinanceArcade app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:my_finance/main.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive for testing
    await Hive.initFlutter();
  });

  tearDownAll(() async {
    // Close Hive boxes after tests
    await Hive.close();
  });

  testWidgets('FinanceArcade app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FinanceArcadeApp());

    // Wait for the app to initialize
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.text('FinanceArcade'), findsOneWidget);

    // Verify that the dashboard shows balance card
    expect(find.text('Total Balance'), findsOneWidget);

    // Verify that navigation bar is present
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Budgets'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
