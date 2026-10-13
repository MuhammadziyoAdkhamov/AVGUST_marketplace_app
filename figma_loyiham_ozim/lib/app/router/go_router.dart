import '../../features/promotions/presentation/screens/promotions_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/coming_soon_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/catalog/presentation/screens/catalog_screen.dart';
import '../../features/catalog/presentation/screens/product_detail_screen.dart';
import '../../features/catalog/presentation/screens/product_video_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/home/presentation/screens/all_categories_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/wholesale/presentation/screens/wholesale_screen.dart';
import '../constants/app_constants.dart';
import 'app_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = ref.read(authProvider).isLoggedIn;
      final loc = state.matchedLocation;
      final authFlow =
          loc == AppRoutes.login ||
          loc == AppRoutes.register ||
          loc == AppRoutes.role;

      if (!loggedIn && !authFlow) return AppRoutes.login;
      if (loggedIn && (loc == AppRoutes.login || loc == AppRoutes.register)) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.role,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) =>
            const ComingSoonScreen(title: 'Bildirishnomalar'),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) =>
            const ComingSoonScreen(title: 'Sozlamalar'),
      ),
      GoRoute(
        path: AppRoutes.help,
        builder: (context, state) =>
            const ComingSoonScreen(title: 'Yordam markazi'),
      ),
      GoRoute(
        path: AppRoutes.about,
        builder: (context, state) =>
            const ComingSoonScreen(title: 'Ilova haqida'),
      ),
      GoRoute(
        path: AppRoutes.promotions,
        builder: (context, state) => const PromotionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) => const ComingSoonScreen(title: 'Xabarlar'),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            RootShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'categories',
                    builder: (context, state) => const AllCategoriesScreen(),
                  ),
                  GoRoute(
                    path: 'wholesale',
                    builder: (context, state) => const WholesaleScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.catalog,
                builder: (context, state) => const CatalogScreen(),
                routes: [
                  GoRoute(
                    path: 'product/:id',
                    builder: (context, state) => ProductDetailScreen(
                      productId: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'video',
                        builder: (context, state) => ProductVideoScreen(
                          productId: state.pathParameters['id']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'favorites',
                    builder: (context, state) => const FavoritesScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
