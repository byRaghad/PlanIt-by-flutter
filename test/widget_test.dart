// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munjez/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // بناء التطبيق وتشغيل أول فريم
    await tester.pumpWidget(const MyApp());

    // تحقق من أن العداد يبدأ من 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // قم بالضغط على الأيقونة '+' وتحفيز فريم آخر.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // تحقق من أن العداد قد تم زيادته.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}