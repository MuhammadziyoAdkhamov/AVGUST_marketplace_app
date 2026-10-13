import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:figma_loyiham_ozim/core/local/session_storage.dart';
import 'package:figma_loyiham_ozim/features/auth/presentation/providers/auth_provider.dart';
import 'package:figma_loyiham_ozim/features/cart/presentation/providers/cart_provider.dart';
import 'package:figma_loyiham_ozim/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:figma_loyiham_ozim/features/catalog/presentation/screens/catalog_screen.dart';
import 'package:figma_loyiham_ozim/features/home/presentation/screens/all_categories_screen.dart';
import 'package:figma_loyiham_ozim/features/home/presentation/screens/home_screen.dart';
import 'package:figma_loyiham_ozim/main.dart';
import 'package:figma_loyiham_ozim/shared/data/mock_catalog.dart';

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

  test('email ro‘yxatdan o‘tish emailni saqlaydi', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    await container
        .read(authProvider.notifier)
        .register(
          identifier: 'test@example.com',
          isEmail: true,
          password: 'StrongPass1!',
        );

    final user = container.read(authProvider).user;
    expect(user?.email, 'test@example.com');
    expect(user?.phone, isEmpty);
  });

  test('signup zaif parolni qabul qilmaydi', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);

    await container
        .read(authProvider.notifier)
        .register(
          identifier: 'test@example.com',
          isEmail: true,
          password: 'password',
        );

    expect(container.read(authProvider).user, isNull);
  });

  test('katalog qidiruvi mahsulot nomini filtrlaydi', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final products = container.read(
      productsProvider((categoryId: null, query: 'iphone')),
    );

    expect(products.map((product) => product.id), ['p3']);
  });

  test('savat mahsulot variantlarini alohida saqlaydi', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final product = MockCatalog.byId('p1')!;
    final cart = container.read(cartProvider.notifier);

    cart.add(product, color: 'Ocean blue', storage: '64 GB');
    cart.add(product, color: 'Black', storage: '64 GB');
    cart.add(product, color: 'Ocean blue', storage: '64 GB');

    final items = container.read(cartProvider);
    expect(items, hasLength(2));
    expect(items.map((item) => item.qty), [2, 1]);

    cart.setQty(items.first.key, 0);
    expect(container.read(cartProvider), hasLength(1));
    expect(container.read(cartProvider).single.color, 'Black');
  });

  testWidgets('katalog route ochilganda mahsulotlar render bo‘ladi', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/catalog',
      routes: [
        GoRoute(
          path: '/catalog',
          builder: (context, state) => const CatalogScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Filtr'), findsOneWidget);
    expect(find.text('Saralash'), findsOneWidget);
    expect(find.textContaining('Oppo A57'), findsOneWidget);
  });

  testWidgets('Home qidiruvi natija va topilmagan holatni ko‘rsatadi', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );
    await tester.pump();

    expect(find.text('Kategoriyalar'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'kansel');
    await tester.pump();
    expect(find.text('Kanselyariya'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'hechqachon-yoq');
    await tester.pump();
    expect(find.text('Mos mahsulot topilmadi'), findsOneWidget);
  });

  testWidgets('barcha kategoriyalar ekrani kategoriya gridini ochadi', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: AllCategoriesScreen())),
    );
    await tester.pump();

    expect(find.text('Barcha kategoriyalar'), findsOneWidget);
    expect(find.text('Velosipedlar', skipOffstage: false), findsOneWidget);
  });
}
