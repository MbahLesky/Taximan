import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taximan_driver/app.dart';

void main() {
  testWidgets('Driver app starts on splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TaximanDriverApp()));

    expect(find.text('Taximan Driver'), findsOneWidget);
    expect(find.text('Drive, earn, and manage trips.'), findsOneWidget);
  });
}
