import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../shared/models/product.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savat'),
        actions: [
          IconButton(
            onPressed: items.isEmpty
                ? null
                : () => ref.read(cartProvider.notifier).clear(),
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.favorites),
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: items.isEmpty
          ? const EmptyView(message: "Savatingiz hozircha bo'sh")
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user_outlined, color: AppColors.loginBlue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Avgust himoyasi\nXaridor va sotuvchi xavfsizligi uchun.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('${items.length} ta Mahsulot'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _CartTile(item: item);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Jami (${items.fold<int>(0, (s, e) => s + e.qty)} ta mahsulot)\n${Product.formatPrice(total)} so\'m',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      FilledButton(
                        onPressed: () => context.go(AppRoutes.orders),
                        child: const Text('Rasmiylashtirish'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartTile extends ConsumerWidget {
  const _CartTile({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.phone_android, size: 48),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (item.color != null)
                  Text('Rang: ${item.color}', style: const TextStyle(fontSize: 11)),
                Text(item.product.priceLabel),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => ref
                    .read(cartProvider.notifier)
                    .setQty(item.product.id, item.qty - 1),
                icon: const Icon(Icons.remove),
              ),
              Text('${item.qty}'),
              IconButton(
                onPressed: () => ref
                    .read(cartProvider.notifier)
                    .setQty(item.product.id, item.qty + 1),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
