import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ако во pubspec.yaml името на пакетот е "recipes_app"
import 'package:recipes_app/main.dart';
// ако името е друго. користи правилното: package:<твоето_име>/main.dart

void main() {
  testWidgets('App boots and shows Categories title', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipesApp());
    // првиот екран има AppBar со 'Categories'
    expect(find.text('Categories'), findsOneWidget);
  });
}
