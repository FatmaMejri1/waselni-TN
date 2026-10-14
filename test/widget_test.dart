import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waselni/main.dart';

void main() {
  testWidgets('App starts on the login placeholder', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Not found'), findsNothing);
  });
}
