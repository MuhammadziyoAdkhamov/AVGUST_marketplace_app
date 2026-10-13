import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_view.dart';
import '../../../catalog/presentation/widgets/product_card.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(favoriteProductsProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Sevimlilar  ${items.length}')),
      body: items.isEmpty
          ? const EmptyView(message: "Sevimlilar hozircha bo'sh")
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 286,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  ProductCard(product: items[index]),
            ),
    );
  }
}
