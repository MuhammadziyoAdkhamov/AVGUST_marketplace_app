import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:figma_loyiham_ozim/core/local/session_storage.dart';
import 'package:figma_loyiham_ozim/features/orders/presentation/providers/orders_provider.dart';
import 'package:figma_loyiham_ozim/features/cart/presentation/providers/cart_provider.dart';
import 'package:figma_loyiham_ozim/shared/data/mock_catalog.dart';
import 'package:figma_loyiham_ozim/shared/models/product.dart';
import 'package:figma_loyiham_ozim/main.dart';

void main() {
  test('namoyish buyurtmasi qayta ochilganda saqlanadi', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final first = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    await first.read(ordersProvider.notifier).place([
      CartItem(product: MockCatalog.products.first, qty: 2, storage: '64 GB'),
    ], 'Toshkent, sinov manzili');
    first.dispose();
    final second = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(second.dispose);
    expect(
      second.read(ordersProvider).single.total,
      MockCatalog.products.first.priceUzs * 2,
    );
    expect(second.read(ordersProvider).single.summary, contains('64 GB'));
    expect(
      second.read(ordersProvider).single.address,
      'Toshkent, sinov manzili',
    );
  });
  testWidgets('390px ekran: namoyish, katalog, savat va buyurtma', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const AugustApp()),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Namoyishni ochish'));
    await tester.tap(find.text('Namoyishni ochish'));
    await tester.pumpAndSettle();
    expect(find.text('Avgust'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Katalog').last);
    await tester.pumpAndSettle();
    expect(find.text('Oppo A57 · 64 GB'), findsOneWidget);
    await tester.tap(find.text('Oppo A57 · 64 GB'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text("Savatchaga qo'shish"),
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await Scrollable.ensureVisible(
      tester.element(find.text("Savatchaga qo'shish")),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text("Savatchaga qo'shish"));
    await tester.pumpAndSettle();
    expect(container.read(cartProvider), hasLength(1));
    await tester.tap(find.text('Savatcha').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Rasmiylashtirish'));
    await tester.tap(find.text('Rasmiylashtirish'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Namoyish buyurtmasini saqlash'));
    await tester.pumpAndSettle();
    expect(find.text('Ismingizni kiriting'), findsOneWidget);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Sinov xaridori');
    await tester.enterText(fields.at(1), '+998901234567');
    await tester.enterText(fields.at(2), 'Toshkent, sinov ko‘chasi, 12');
    await tester.ensureVisible(find.text('Namoyish buyurtmasini saqlash'));
    await tester.tap(find.text('Namoyish buyurtmasini saqlash'));
    await tester.pumpAndSettle();
    expect(container.read(ordersProvider), hasLength(1));
    expect(container.read(cartProvider), isEmpty);
    expect(find.text('Buyurtmalarim'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
