import 'package:flutter_application_1/main.dart'; // Ensure this matches your project name
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Finance App login smoke test', (WidgetTester tester) async {
    // 1. Change MyApp() to MyFinanceApp()
    await tester.pumpWidget(const ZyPayApp());

    // 2. Check if the Welcome text from your new login design exists
    expect(find.textContaining('Welcome'), findsOneWidget);
  });
}