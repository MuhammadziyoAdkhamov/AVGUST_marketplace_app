import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/mock_catalog.dart';
import '../../../../shared/models/product.dart';

final productsProvider = Provider.family<List<Product>, String?>((
  ref,
  categoryId,
) {
  return MockCatalog.byCategory(categoryId);
});

final productProvider = Provider.family<Product?, String>((ref, id) {
  return MockCatalog.byId(id);
});

final wholesaleProductsProvider = Provider<List<Product>>((ref) {
  return MockCatalog.products.where((p) => p.wholesale).toList();
});
