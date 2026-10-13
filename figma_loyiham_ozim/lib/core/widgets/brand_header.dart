import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key, this.showMenu = false, this.onMenu});
  final bool showMenu;
  final VoidCallback? onMenu;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        if (showMenu)
          IconButton(
            onPressed: onMenu,
            tooltip: 'Menyu',
            icon: const Icon(Icons.menu),
          ),
        const Text('avgust', style: AppTextStyles.brand),
        const Padding(
          padding: EdgeInsets.only(left: 3, bottom: 15),
          child: Icon(Icons.circle, size: 7, color: AppColors.brand),
        ),
        const Spacer(),
        IconButton.filledTonal(
          onPressed: () => context.push(AppRoutes.favorites),
          tooltip: 'Sevimlilar',
          style: IconButton.styleFrom(backgroundColor: Colors.white),
          icon: const Icon(Icons.favorite_border, size: 22),
        ),
        const SizedBox(width: 6),
        IconButton.filledTonal(
          onPressed: () => context.push(AppRoutes.notifications),
          tooltip: 'Bildirishnomalar',
          style: IconButton.styleFrom(backgroundColor: Colors.white),
          icon: const Icon(Icons.notifications_none_rounded, size: 23),
        ),
      ],
    ),
  );
}
