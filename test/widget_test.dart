import 'package:flutter_test/flutter_test.dart';
import 'package:agro_market/main.dart';

void main() {
  testWidgets('Agro Market app loads successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AgroMarketApp());

    expect(find.text('Agro Market'), findsOneWidget);
    expect(find.text('Fresh Farm Products'), findsOneWidget);
  });
}