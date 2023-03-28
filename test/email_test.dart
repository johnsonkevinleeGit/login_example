import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/main.dart';

const pleaseEnterYourEmail = 'Please enter your email.';
const twentyFiveCharsMax = '25 characters max.';
const invalidEmail = 'Invalid email.';

void main() {
  testWidgets('Email empty field test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    final emailField = find.byType(TextFormField).first;

    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');

    await tester.enterText(emailField, '');
    await tester.pumpAndSettle();
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    expect(find.text(pleaseEnterYourEmail), findsOneWidget);
  });

  testWidgets('Email over max character test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    final emailField = find.byType(TextFormField).first;

    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');

    await tester.enterText(
        emailField, 'kevinthisIsATestthisIsATest@thisIsATest.com');
    await tester.pumpAndSettle();
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    expect(find.text(twentyFiveCharsMax), findsOneWidget);
  });

  testWidgets('Email over max character test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    final emailField = find.byType(TextFormField).first;

    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');

    await tester.enterText(emailField, 'kevin');
    await tester.pumpAndSettle();
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    expect(find.text(invalidEmail), findsOneWidget);
  });

  testWidgets('Email valid test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    final emailField = find.byType(TextFormField).first;

    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');

    await tester.enterText(emailField, 'kevin@test.com');
    await tester.pumpAndSettle();
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    expect(find.text(pleaseEnterYourEmail), findsNothing);
    expect(find.text(twentyFiveCharsMax), findsNothing);
    expect(find.text(invalidEmail), findsNothing);
  });
}
