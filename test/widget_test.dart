import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deen/main.dart';

void main() {
  testWidgets('DEEN app starts and bottom navigation opens Files',
      (WidgetTester tester) async {
    await tester.pumpWidget(const DeenApp());

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Assalamu Alaikum'), findsOneWidget);

    await tester.tap(find.text('Files'));
    await tester.pumpAndSettle();

    expect(find.text('Personal Files'), findsOneWidget);
  });
}
