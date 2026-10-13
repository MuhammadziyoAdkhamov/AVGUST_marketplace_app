import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/product.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import 'product_image.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liked = ref.watch(favoritesProvider).contains(product.id);
    final discount =
        product.oldPriceUzs != null && product.oldPriceUzs! > product.priceUzs
        ? ((1 - product.priceUzs / product.oldPriceUzs!) * 100).round()
        : 0;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.product(product.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ProductImage(product: product),
                  ),
                  if (discount > 0)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2A6),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          '−$discount%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton(
                      tooltip: liked
                          ? 'Sevimlilardan olib tashlash'
                          : 'Sevimlilarga qo‘shish',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => ref
                          .read(favoritesProvider.notifier)
                          .toggle(product.id),
                      icon: Icon(
                        liked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 20,
                        color: liked ? const Color(0xFFD36070) : AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 3, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.star,
                        size: 16,
                      ),
                      Text(
                        ' ${product.rating}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '  (${product.reviewCount})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    discount > 0
                        ? '${Product.formatPrice(product.oldPriceUzs!)} so‘m'
                        : 'Mavjud',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.muted,
                      decoration: discount > 0
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.priceLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 36,
                        height: 40,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: 'Savatga qo‘shish',
                          onPressed: !product.inStock
                              ? null
                              : () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .add(
                                        product,
                                        color: product.colors.firstOrNull,
                                        storage: product.storages.firstOrNull,
                                      );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Mahsulot savatga qo‘shildi',
                                        ),
                                        action: SnackBarAction(
                                          label: 'Savat',
                                          onPressed: () =>
                                              context.go(AppRoutes.cart),
                                        ),
                                      ),
                                    );
                                },
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.brandSoft,
                            foregroundColor: AppColors.brandDark,
                          ),
                          icon: const Icon(Icons.add_rounded, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
