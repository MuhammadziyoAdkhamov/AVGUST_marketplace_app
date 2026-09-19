import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:figma_loyiham_ozim/core/local/session_storage.dart';
import 'package:figma_loyiham_ozim/main.dart';

void main() {
  testWidgets('login sahifasi ochiladi', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const AugustApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tizimga kirish'), findsOneWidget);
  });
}
