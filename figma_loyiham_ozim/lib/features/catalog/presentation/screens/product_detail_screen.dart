import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/product.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../providers/catalog_provider.dart';
import '../widgets/product_image.dart';

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
    final selectedColor = product.colors.isEmpty
        ? null
        : product.colors[colorIndex
              .clamp(0, product.colors.length - 1)
              .toInt()];
    final selectedStorage = product.storages.isEmpty
        ? null
        : product.storages[storageIndex
              .clamp(0, product.storages.length - 1)
              .toInt()];
    final discountPercent =
        product.oldPriceUzs != null && product.oldPriceUzs! > product.priceUzs
        ? ((product.oldPriceUzs! - product.priceUzs) *
                  100 /
                  product.oldPriceUzs!)
              .round()
        : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.catalog);
            }
          },
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
          AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffeaf0f5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: ProductImage(product: product),
              ),
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
              ...List.generate(5, (index) {
                final filled = product.rating >= index + 1;
                final half = !filled && product.rating > index;
                return Icon(
                  half ? Icons.star_half : Icons.star,
                  color: filled || half ? AppColors.star : Colors.grey.shade300,
                  size: 16,
                );
              }),
              const SizedBox(width: 6),
              Text(product.rating.toStringAsFixed(1)),
              const SizedBox(width: 8),
              Text(
                '${product.reviewCount} ta baho',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 4,
            children: [
              Text(
                product.priceLabel,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (product.oldPriceUzs != null &&
                  product.oldPriceUzs! > product.priceUzs)
                Text(
                  '${Product.formatPrice(product.oldPriceUzs!)} so‘m',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              if (discountPercent != null)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.brandSoft,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    child: Text(
                      '-$discountPercent%',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.brandDark,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (product.colors.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Rang: ${selectedColor ?? ''}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: [
                for (var i = 0; i < product.colors.length; i++)
                  _ColorOption(
                    label: product.colors[i],
                    selected: colorIndex == i,
                    onTap: () => setState(() => colorIndex = i),
                  ),
              ],
            ),
          ],
          if (product.storages.isNotEmpty) ...[
            const SizedBox(height: 18),
            const Text('Xotira', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < product.storages.length; i++)
                  OutlinedButton(
                    onPressed: () => setState(() => storageIndex = i),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: storageIndex == i
                          ? AppColors.brandDark
                          : AppColors.text,
                      side: BorderSide(
                        color: storageIndex == i
                            ? AppColors.brand
                            : AppColors.border,
                      ),
                      minimumSize: const Size(66, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Text(
                      product.storages[i],
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe5e5e5)),
              borderRadius: BorderRadius.circular(20),
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
                      Text(
                        'Sotuvchi',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () => ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Do‘kon sahifasi do‘kon ma’lumotlari ulangach ochiladi.',
                        ),
                      ),
                    ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(75, 30),
                  ),
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
              onPressed: product.inStock
                  ? () {
                      ref
                          .read(cartProvider.notifier)
                          .add(
                            product,
                            color: selectedColor,
                            storage: selectedStorage,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Savatchaga qo'shildi")),
                      );
                    }
                  : null,
              icon: Icon(
                product.inStock
                    ? Icons.shopping_cart_outlined
                    : Icons.remove_shopping_cart_outlined,
              ),
              label: Text(
                product.inStock ? "Savatchaga qo'shish" : 'Sotuvda yo‘q',
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 42,
            child: OutlinedButton.icon(
              onPressed: () =>
                  ref.read(favoritesProvider.notifier).toggle(product.id),
              icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
              label: Text(liked ? 'Sevimlilarda' : "Sevimlilarga qo'shish"),
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
              (e) => Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.key,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(e.value, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
          const Divider(height: 32),
          Text(
            'Sharhlar (${product.reviewCount})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          if (product.reviewCount == 0)
            Text(
              'Hozircha mahsulotga baho berilmagan.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            )
          else
            Row(
              children: [
                Text(
                  product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: List.generate(
                          5,
                          (_) => const Icon(
                            Icons.star,
                            color: AppColors.star,
                            size: 16,
                          ),
                        ),
                      ),
                      Text(
                        '${product.reviewCount} ta baho asosida',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  Color get _swatchColor {
    final value = label.toLowerCase();
    if (value.contains('black')) return const Color(0xFF222222);
    if (value.contains('blue')) return const Color(0xFF4F65D9);
    if (value.contains('red')) return const Color(0xFFD64B4B);
    if (value.contains('pink')) return const Color(0xFFE9A9B9);
    if (value.contains('lilac') || value.contains('purple')) {
      return const Color(0xFF9A83C7);
    }
    if (value.contains('white')) return Colors.white;
    return const Color(0xFFB8BDC3);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 30,
            height: 30,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.brandDark : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _swatchColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: selected
                  ? Icon(
                      Icons.check,
                      size: 13,
                      color: _swatchColor.computeLuminance() < 0.45
                          ? Colors.white
                          : AppColors.text,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
