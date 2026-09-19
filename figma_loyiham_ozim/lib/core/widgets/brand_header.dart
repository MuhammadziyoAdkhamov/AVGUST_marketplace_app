import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_text_styles.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key, this.showMenu = false, this.onMenu});

  final bool showMenu;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showMenu)
          IconButton(
            onPressed: onMenu,
            icon: const Icon(Icons.menu),
          ),
        const Text(AppConstants.appName, style: AppTextStyles.brand),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chat_bubble_outline, size: 20),
        ),
        IconButton(
          onPressed: () => context.push(AppRoutes.notifications),
          icon: const Icon(Icons.notifications_none, size: 22),
        ),
      ],
    );
  }
}
