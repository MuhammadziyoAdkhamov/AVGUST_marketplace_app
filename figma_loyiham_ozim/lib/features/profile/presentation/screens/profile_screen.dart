import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/user_role.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool panel = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final seller = user?.activeMode == ActiveMode.seller;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 45)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Foydalanuvchi',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(user?.phone ?? ''),
                      const SizedBox(height: 8),
                      Text(user?.email ?? ''),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.push(AppRoutes.notifications),
                  icon: const Icon(Icons.notifications_none, size: 28),
                ),
                IconButton(
                  onPressed: () => context.push(AppRoutes.settings),
                  icon: const Icon(Icons.settings_outlined, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, size: 29),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Joriy rejim', style: TextStyle(fontSize: 11)),
                        Text(
                          seller ? 'Sotuvchi' : 'Xaridor',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => panel = !panel),
                    child: const Text(
                      "O'zgartirish",
                      style: TextStyle(color: AppColors.brand),
                    ),
                  ),
                ],
              ),
            ),
            if (panel)
              _Panel(
                seller: seller,
                onSeller: () async {
                  await ref
                      .read(authProvider.notifier)
                      .setActiveMode(ActiveMode.seller);
                  setState(() => panel = false);
                },
                onBuyer: () async {
                  await ref
                      .read(authProvider.notifier)
                      .setActiveMode(ActiveMode.buyer);
                  setState(() => panel = false);
                },
                close: () => setState(() => panel = false),
              ),
            const SizedBox(height: 28),
            const Text(
              "Asosiy bo'limlar",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            _Item('Buyurtmalarim', Icons.receipt_long_outlined, () {
              context.go(AppRoutes.orders);
            }),
            _Item('Sevimlilar', Icons.favorite_border, () {
              context.push(AppRoutes.favorites);
            }),
            _Item('Aksiyalar', Icons.local_offer_outlined, () {
              context.push(AppRoutes.promotions);
            }),
            _Item('Sozlamalar', Icons.settings_outlined, () {
              context.push(AppRoutes.settings);
            }),
            const SizedBox(height: 18),
            const Text(
              "Qo'shimcha",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            _Item("Sotuvchi bo'lish", Icons.storefront_outlined, () {
              setState(() => panel = true);
            }),
            _Item("Do'kon ochish", Icons.store_outlined, () {
              context.push(AppRoutes.about);
            }),
            _Item('Yordam markazi', Icons.headset_mic_outlined, () {
              context.push(AppRoutes.help);
            }),
            _Item('Ilova haqida', Icons.info_outline, () {
              context.push(AppRoutes.about);
            }),
            _Item('Chiqish', Icons.logout, () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.login);
            }),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this.text, this.icon, this.tap);
  final String text;
  final IconData icon;
  final VoidCallback tap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Icon(icon, size: 21),
      title: Text(text, style: const TextStyle(fontSize: 17)),
      trailing: const Icon(Icons.chevron_right),
      onTap: tap,
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.seller,
    required this.onSeller,
    required this.onBuyer,
    required this.close,
  });
  final bool seller;
  final VoidCallback onSeller;
  final VoidCallback onBuyer;
  final VoidCallback close;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rejimni tanlang',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 7),
          const Text(
            'Kerakli rejimni tanlab platformadan\nqulay foydalaning',
          ),
          const SizedBox(height: 15),
          _Choice(
            'Xaridor rejimi',
            'Mahsulotni qidirish va\nxarid qilish',
            !seller,
            onBuyer,
          ),
          const SizedBox(height: 10),
          _Choice(
            "So'tuvchi rejimi",
            "Do'kon boshqarish, mahsulot\njoylash va sotish",
            seller,
            onSeller,
          ),
          const SizedBox(height: 17),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: close,
              child: const Text('Bekor qilish'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice(this.title, this.body, this.active, this.tap);
  final String title;
  final String body;
  final bool active;
  final VoidCallback tap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: active ? AppColors.brandSoft : Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 5),
                  Text(body, textAlign: TextAlign.center),
                ],
              ),
            ),
            Icon(
              Icons.circle,
              color: active ? const Color(0xff70e87b) : const Color(0xffdddddd),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
