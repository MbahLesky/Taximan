import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taximan_passenger/app.dart';

void main() {
  testWidgets('Passenger app starts on splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TaximanPassengerApp()));

    expect(find.text('Taximan Passenger'), findsOneWidget);
    expect(find.text('Book trusted rides in minutes.'), findsOneWidget);
  });
}
