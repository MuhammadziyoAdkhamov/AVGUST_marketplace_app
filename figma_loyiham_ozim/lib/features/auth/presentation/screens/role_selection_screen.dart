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
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 72, 22, 24),
                child: Column(
                  children: [
                    const Text(
                      'Siz nima qilishni\nxohlaysiz?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "O'zingizga mos rolni tanlang",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 38),
                    _RoleCard(
                      icon: Image.asset(
                        'assets/images/role_screen/buy.png',
                        width: 54,
                        height: 54,
                        fit: BoxFit.contain,
                      ),
                      title: 'Xarid qilish',
                      subtitle:
                          'Mahsulotni qidirish, buyurtma berish\nva xarid qilish',
                      selected: _selected == UserRole.buyer,
                      onTap: () => setState(() => _selected = UserRole.buyer),
                    ),
                    const SizedBox(height: 12),
                    _RoleCard(
                      icon: Image.asset(
                        'assets/images/role_screen/sell.png',
                        width: 54,
                        height: 54,
                        fit: BoxFit.contain,
                      ),
                      title: 'Mahsulot sotish',
                      subtitle: "Do'kon ochish mahsulot\njoylash va sotish",
                      selected: _selected == UserRole.seller,
                      onTap: () => setState(() => _selected = UserRole.seller),
                    ),
                    const SizedBox(height: 12),
                    _RoleCard(
                      icon: Image.asset(
                        'assets/images/role_screen/buy_and_sell.png',
                        width: 54,
                        height: 54,
                        fit: BoxFit.contain,
                      ),
                      title: 'Mahsulot va Xarid',
                      subtitle: 'Mahsulot sotish va\nXarid qilish ham',
                      selected: _selected == UserRole.both,
                      onTap: () => setState(() => _selected = UserRole.both),
                    ),
                    const SizedBox(height: 28),
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
  final Widget icon;
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
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandSoft : Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(width: 64, height: 64, child: icon),
            const SizedBox(width: 16),
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
