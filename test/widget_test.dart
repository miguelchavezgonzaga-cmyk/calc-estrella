// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:calc_cientifica_estrella/main.dart';

void main() {
  testWidgets('muestra splash y luego la calculadora', (WidgetTester tester) async {
    await tester.pumpWidget(const CalcApp());
    expect(find.textContaining('CETIS'), findsWidgets);
    expect(find.textContaining('Valentina'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3300));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('CE'), findsOneWidget);
    expect(find.text('0'), findsWidgets);
  });
}
