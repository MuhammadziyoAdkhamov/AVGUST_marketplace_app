import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../providers/catalog_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int colorIndex = 0;
  int storageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productProvider(widget.productId));
    if (product == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: const Center(child: Text('Mahsulot topilmadi')),
      );
    }

    final liked = ref.watch(favoritesProvider).contains(product.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () => context.go(AppRoutes.cart),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          IconButton(
            onPressed: () =>
                ref.read(favoritesProvider.notifier).toggle(product.id),
            icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Container(
            height: 270,
            color: const Color(0xffdcebf8),
            child: const Center(
              child: Icon(Icons.phone_android, size: 155, color: Color(0xff768f9d)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () =>
                    context.push(AppRoutes.productVideo(product.id)),
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Video'),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${product.rating}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 4),
              ...List.generate(
                5,
                (_) => const Icon(Icons.star, color: AppColors.star, size: 15),
              ),
              const SizedBox(width: 8),
              Text(
                '(${product.reviewCount}) Sharh',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            product.priceLabel,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Text(
            'Rang',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (var i = 0; i < product.colors.length; i++)
                ChoiceChip(
                  label: Text(product.colors[i], style: const TextStyle(fontSize: 11)),
                  selected: colorIndex == i,
                  onSelected: (_) => setState(() => colorIndex = i),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Xotira', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < product.storages.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: OutlinedButton(
                    onPressed: () => setState(() => storageIndex = i),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: storageIndex == i
                          ? AppColors.brandSoft
                          : null,
                    ),
                    child: Text(
                      product.storages[i],
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe5e5e5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const CircleAvatar(child: Icon(Icons.storefront)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.sellerName,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Text(
                        '5.0  •  5 yildan beri',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(minimumSize: const Size(75, 30)),
                  child: const Text(
                    "Do'konga o'tish",
                    style: TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: () {
                ref
                    .read(cartProvider.notifier)
                    .add(
                      product,
                      color: product.colors[colorIndex],
                      storage: product.storages[storageIndex],
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Savatchaga qo'shildi")),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text("Savatchaga qo'shish"),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 42,
            child: OutlinedButton.icon(
              onPressed: () =>
                  ref.read(favoritesProvider.notifier).toggle(product.id),
              icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
              label: Text(
                liked ? 'Sevimlilarda' : "Sevimlilarga qo'shish",
              ),
            ),
          ),
          const Divider(height: 38),
          const Text(
            'Tavsif',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            product.description.isEmpty
                ? 'Mahsulot tavsifi tez orada.'
                : product.description,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
          ),
          if (product.specs.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Asosiy xususiyatlar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            ...product.specs.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${e.key}: ${e.value}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
