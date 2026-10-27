import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter_navigation/main.dart';

void main() {
  testWidgets('navigates into a converter and handles invalid input', (tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const UnitConverterApp());

    expect(find.text('Choose a category'), findsOneWidget);
    await tester.tap(find.text('Length'));
    await tester.pumpAndSettle();
    expect(find.text('Length Converter'), findsOneWidget);
    expect(find.text('0.0010 km'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'not a number');
    await tester.pump();
    expect(find.text('Enter a valid number to convert.'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Choose a category'), findsOneWidget);

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
