import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/mock_catalog.dart';
import '../../../../shared/models/product.dart';

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String productId) {
    final next = {...state};
    if (!next.add(productId)) next.remove(productId);
    state = next;
  }

  bool contains(String id) => state.contains(id);
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);

final favoriteProductsProvider = Provider<List<Product>>((ref) {
  final ids = ref.watch(favoritesProvider);
  return MockCatalog.products.where((p) => ids.contains(p.id)).toList();
});
