import 'package:flutter_test/flutter_test.dart';
import 'package:edusnap/Utils/AppLocaleController.dart';
import 'package:edusnap/main.dart';

void main() {
  testWidgets('EduSnap smoke test', (WidgetTester tester) async {
    final localeController = AppLocaleController();
    await tester.pumpWidget(MyApp(localeController: localeController));
    expect(find.byType(MyApp), findsOneWidget);
  });
}