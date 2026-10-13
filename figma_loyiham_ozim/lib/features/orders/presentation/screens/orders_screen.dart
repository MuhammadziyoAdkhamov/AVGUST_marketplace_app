import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/product.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Buyurtmalarim')),
      body: orders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: AppColors.brandSoft,
                      child: Icon(
                        Icons.receipt_long_outlined,
                        size: 38,
                        color: AppColors.brandDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Birinchi xaridingiz shu yerdan boshlanadi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Buyurtmalaringizni shu sahifada kuzatishingiz mumkin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => context.go(AppRoutes.catalog),
                      child: const Text('Mahsulotlarni ko‘rish'),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Namoyish buyurtmalari. Sotuvchiga yuborilmaydi va to‘lov olinmaydi.',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 16),
                ...orders.map(
                  (o) => Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.brandDark,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '№ ${o.id.substring(o.id.length - 8)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const Text(
                              'Namoyish',
                              style: TextStyle(
                                color: AppColors.brandDark,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${o.createdAt.day}.${o.createdAt.month}.${o.createdAt.year}',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                        const Divider(height: 26),
                        Text(o.summary),
                        const SizedBox(height: 14),
                        Text(
                          o.address,
                          style: const TextStyle(color: AppColors.muted),
                        ),
                        const Divider(height: 26),
                        Text(
                          '${Product.formatPrice(o.total)} so‘m',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
