import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/user_role.dart';
import '../providers/auth_provider.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  UserRole _selected = UserRole.buyer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 48, 26, 34),
              child: Column(
                children: [
                  const Text(
                    'Siz nima qilishni\nhohlaysiz ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "O'zingizga mos rolni tanlang",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 48),
                  _RoleCard(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Xarid qilish',
                    subtitle:
                        'Mahsulotni qidirish\nbuyurtma berish\nva harid qilish',
                    selected: _selected == UserRole.buyer,
                    onTap: () => setState(() => _selected = UserRole.buyer),
                  ),
                  const SizedBox(height: 12),
                  _RoleCard(
                    icon: Icons.storefront_outlined,
                    title: 'Mahsulot sotish',
                    subtitle: "Do'kon ochish mahsulot\njoylash va sotish",
                    selected: _selected == UserRole.seller,
                    onTap: () => setState(() => _selected = UserRole.seller),
                  ),
                  const SizedBox(height: 12),
                  _RoleCard(
                    icon: Icons.sync_alt,
                    title: 'Mahsulot va Xarid',
                    subtitle: 'Mahsulot sotish va\nXarid qilish ham',
                    selected: _selected == UserRole.both,
                    onTap: () => setState(() => _selected = UserRole.both),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () async {
                        await ref
                            .read(authProvider.notifier)
                            .setRole(_selected);
                        if (context.mounted) context.go(AppRoutes.home);
                      },
                      child: const Text('Davom etish'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 112,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandSoft : Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 55),
            const SizedBox(width: 28),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.25),
                  ),
                ],
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: selected ? const Color(0xff70e87b) : Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
