import 'package:flutter_test/flutter_test.dart';

import 'package:about/main.dart';

void main() {
  testWidgets('Portfolio loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PortfolioApp());

    // Verify that portfolio renders
    expect(find.text('Yuvaraj S'), findsOneWidget);
  });
}
