import 'package:blood/controllers/fireStoreDatabaseController.dart';
import 'package:blood/views/user/request_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class MockFireStoreDatabaseController extends Mock implements fireStoreDatabaseController {}
void main() {
  late MockFireStoreDatabaseController mockController;

  setUp(() {
    mockController = MockFireStoreDatabaseController();
  });
  Widget createWidgetUnderTest() {
    Get.put(mockController); // Provide the mock controller to GetX
    return const MaterialApp(
      home: RequestForm(),
    );
  }

  group('RequestForm Integration Tests', () {
    testWidgets('Submitting a valid form adds a request and shows success snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid data into the form fields
      await tester.enterText(find.widget<TextFormField>(that.hasHintText('e.g. Mohammad Aliar')), 'Test Patient');
      await tester.enterText(find.widget<IntlPhoneField>(find.byType(IntlPhoneField)), '+923001234567');
      await tester.enterText(find.widget<TextFormField>(that.hasHintText('e.g. Lahore children hospital')), 'Test Hospital');
      await tester.tap(find.byWidgetPredicate((widget) => widget is DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Anemia').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.widget<TextFormField>(that.hasHintText('e.g 3')), '2');
      await tester.enterText(find.widget<TextFormField>(that.hasHintText('Needed in emergence')), 'Urgent request');
      await tester.tap(find.widget<ChoiceChip>(that.hasLabel('A+')));
      await tester.tap(find.widget<ChoiceChip>(that.hasIcon(const Icon(Icons.man, size: 40))));

      await tester.tap(find.widget<ElevatedButton>(that.hasText('Submit')));
      await tester.pumpAndSettle();

      verify(mockController.addRequest(
        'Test Patient',
        '+923001234567',
        'Test Hospital',
        'Anemia',
        2,
        'A+',
        'Male',
        'Urgent request',
      )).called(1);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Request added successfully!'), findsOneWidget);
    });
    testWidgets('Submitting with "None" selected in dropdown does not add request', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.widget<TextFormField>(that.hasHintText('e.g. Mohammad Aliar')), 'Test Patient');
      await tester.tap(find.widget<DropdownButtonFormField<String>>);
      await tester.pumpAndSettle();
      await tester.tap(find.text('None').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widget<ChoiceChip>(that.hasLabel('B-')));
      await tester.tap(find.widget<ChoiceChip>(that.hasIcon(const Icon(Icons.woman, size: 40))));
      await tester.tap(find.widget<ElevatedButton>(that.hasText('Submit')));
      await tester.pumpAndSettle();
      verifyNever(mockController.addRequest(any, any, any, any, any, any, any, any));
      expect(find.byType(SnackBar), findsNothing);
      // You could add an expectation here if you were showing an error for not selecting a case.
    });

    testWidgets('Submitting with "Others" and entering text adds request with that text', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.widget<TextFormField>(that.hasHintText('e.g. Mohammad Aliar')), 'Another Patient');
      await tester.tap(find.widget<DropdownButtonFormField<String>>);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Others').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.widget<TextFormField>(that.hasLabel('Enter other option')), 'Specific Condition');
      await tester.tap(find.widget<ChoiceChip>(that.hasLabel('AB+')));
      await tester.tap(find.widget<ChoiceChip>(that.hasIcon(const Icon(Icons.woman, size: 40))));

      // Tap the submit button
      await tester.tap(find.widget<ElevatedButton>(that.hasText('Submit')));
      await tester.pumpAndSettle();

      verify(mockController.addRequest(
        'Another Patient',
        null,
        '',
        'Specific Condition',
        0,    // Bags might default if not entered
        'AB+',
        'Female',
        null, // Details are optional
      )).called(1);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Request added successfully!'), findsOneWidget);
    });

    testWidgets('Tapping location icon updates location field', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      const mockAddress = '123 Test Street, Test City, Test Region, 12345';
      when(mockController.addRequest(any, any, any, any, any, any, any, any)).thenAnswer((_) async {});

      // Simulate successful location retrieval
      await tester.tap(find.byIcon(Icons.my_location));
      await tester.pumpAndSettle();


      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('e.g. Lahore children hospital'), findsNothing);
    });
  });
}