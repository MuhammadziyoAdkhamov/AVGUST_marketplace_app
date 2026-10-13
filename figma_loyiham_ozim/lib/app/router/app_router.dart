import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

class RootShell extends ConsumerWidget {
  const RootShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref
        .watch(cartProvider)
        .fold(0, (sum, item) => sum + item.qty);
    final items = [
      _NavItemData(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Bosh sahifa',
      ),
      _NavItemData(
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view,
        label: 'Katalog',
      ),
      _NavItemData(
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart,
        label: 'Savatcha',
      ),
      _NavItemData(
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long,
        label: 'Buyurtma',
      ),
      _NavItemData(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profil',
      ),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: navigationShell.currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: AppColors.brandSoft,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          for (final item in items)
            NavigationDestination(
              icon: item.label == 'Savatcha' && count > 0
                  ? Badge(label: Text('$count'), child: Icon(item.icon))
                  : Icon(item.icon),
              selectedIcon: Icon(item.activeIcon),
              label: item.label,
            ),
        ],
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
