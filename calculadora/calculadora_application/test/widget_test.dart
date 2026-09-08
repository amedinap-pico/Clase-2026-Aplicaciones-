import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculadora_application/main.dart';

void main() {
  testWidgets('calculates total and split amount', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byKey(const ValueKey('billInput')), '120');
    await tester.enterText(find.byKey(const ValueKey('peopleInput')), '4');
    await tester.pump();

    expect(find.text('Total: \$144.00'), findsOneWidget);
    expect(find.text('Por persona: \$36.00'), findsOneWidget);
  });

  testWidgets('rounds the split amount up when enabled', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byKey(const ValueKey('billInput')), '101');
    await tester.enterText(find.byKey(const ValueKey('peopleInput')), '3');
    await tester.tap(find.byKey(const ValueKey('roundSwitch')));
    await tester.pump();

    expect(find.text('Por persona: \$41.00'), findsOneWidget);
  });

  testWidgets('opens the network image route', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Ver imagen de red'));
    await tester.pumpAndSettle();

    expect(find.text('Imagen desde internet'), findsOneWidget);
    expect(find.byType(NetworkImageView), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
