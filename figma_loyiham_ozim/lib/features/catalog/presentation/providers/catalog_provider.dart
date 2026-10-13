import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/mock_catalog.dart';
import '../../../../shared/models/product.dart';

typedef CatalogFilter = ({String? categoryId, String? query});

final productsProvider = Provider.family<List<Product>, CatalogFilter>((
  ref,
  filter,
) {
  final query = filter.query?.trim().toLowerCase() ?? '';
  return MockCatalog.products.where((product) {
    final matchesCategory =
        filter.categoryId == null ||
        filter.categoryId == 'all' ||
        product.categoryId == filter.categoryId;
    final matchesQuery =
        query.isEmpty || product.title.toLowerCase().contains(query);
    return matchesCategory && matchesQuery;
  }).toList();
});

final productProvider = Provider.family<Product?, String>((ref, id) {
  return MockCatalog.byId(id);
});

final wholesaleProductsProvider = Provider<List<Product>>((ref) {
  return MockCatalog.products.where((p) => p.wholesale).toList();
});
