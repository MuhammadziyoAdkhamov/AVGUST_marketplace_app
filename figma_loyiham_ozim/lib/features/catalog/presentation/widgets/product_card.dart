import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../shared/models/product.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liked = ref.watch(favoritesProvider).contains(product.id);
    final preview = _previewStyle(product.categoryId);

    return InkWell(
      onTap: () => context.go(AppRoutes.product(product.id)),
      borderRadius: BorderRadius.circular(8),
      child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE1E1E1)),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(9, 9, 9, 4),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: preview.$1,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(preview.$2, size: 48, color: preview.$3),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.priceLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              size: 10,
                              color: Color(0xFFFFB400),
                            ),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  padding: const EdgeInsets.all(5),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    size: 16,
                    color: liked ? Colors.red : const Color(0xFF424242),
                  ),
                  onPressed: () =>
                      ref.read(favoritesProvider.notifier).toggle(product.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, IconData, Color) _previewStyle(String categoryId) {
    switch (categoryId) {
      case 'beauty':
        return (
          const Color(0xFFFFF5F2),
          Icons.local_florist_outlined,
          const Color(0xFFE68A82),
        );
      case 'kids':
        return (
          const Color(0xFFFFF4D7),
          Icons.toys_outlined,
          const Color(0xFFE6A73B),
        );
      case 'home':
        return (
          const Color(0xFFF2F0E8),
          Icons.inventory_2_outlined,
          const Color(0xFF9B8B62),
        );
      default:
        return (
          const Color(0xFFE7F1F8),
          Icons.phone_android,
          const Color(0xFF63849A),
        );
    }
  }
}
