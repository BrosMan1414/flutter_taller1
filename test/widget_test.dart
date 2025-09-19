// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_taller1/main.dart';

void main() {
  testWidgets('Navigation and Counter test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Verify that we're on the home screen
    expect(find.text('Taller 1 - Navegación'), findsOneWidget);
    
    // Test lifecycle card elements
    expect(find.text('Ciclo de Vida del Widget'), findsOneWidget);
    expect(find.text('Trigger setState'), findsOneWidget);
    
    // Tap the setState trigger button
    await tester.tap(find.text('Trigger setState'));
    await tester.pump();
    
    // Verify lifecycle card updated
    expect(find.textContaining('setState llamado'), findsOneWidget);
  });
}
