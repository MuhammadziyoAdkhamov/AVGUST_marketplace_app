import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../core/widgets/brand_header.dart';
import '../../../../shared/data/mock_catalog.dart';
import '../../../../shared/models/product.dart';
import '../providers/catalog_provider.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

enum _ProductSort { recommended, priceLowToHigh, priceHighToLow, rating }

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  RangeValues _priceRange = const RangeValues(0, 20000000);
  bool _inStockOnly = false;
  _ProductSort _sort = _ProductSort.recommended;

  String get _sortLabel => switch (_sort) {
    _ProductSort.recommended => 'Tavsiya etilgan',
    _ProductSort.priceLowToHigh => 'Arzonidan qimmatiga',
    _ProductSort.priceHighToLow => 'Qimmatidan arzoniga',
    _ProductSort.rating => 'Reyting bo‘yicha',
  };

  Future<void> _showFilterSheet() async {
    var draftRange = _priceRange;
    var draftInStock = _inStockOnly;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrlar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),
                const Text('Narx oralig‘i'),
                RangeSlider(
                  values: draftRange,
                  min: 0,
                  max: 20000000,
                  divisions: 40,
                  labels: RangeLabels(
                    '${Product.formatPrice(draftRange.start.round())} so‘m',
                    '${Product.formatPrice(draftRange.end.round())} so‘m',
                  ),
                  onChanged: (value) => setSheetState(() => draftRange = value),
                ),
                Text(
                  '${Product.formatPrice(draftRange.start.round())} - ${Product.formatPrice(draftRange.end.round())} so‘m',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
                const SizedBox(height: 8),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Faqat mavjud mahsulotlar'),
                  value: draftInStock,
                  onChanged: (value) =>
                      setSheetState(() => draftInStock = value),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => setSheetState(() {
                        draftRange = const RangeValues(0, 20000000);
                        draftInStock = false;
                      }),
                      child: const Text('Tozalash'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _priceRange = draftRange;
                          _inStockOnly = draftInStock;
                        });
                        Navigator.of(sheetContext).pop();
                      },
                      child: const Text('Natijalarni ko‘rish'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showSortSheet() async {
    final selection = await showModalBottomSheet<_ProductSort>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'Saralash',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
            RadioGroup<_ProductSort>(
              groupValue: _sort,
              onChanged: (value) => Navigator.of(context).pop(value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final option in _ProductSort.values)
                    RadioListTile<_ProductSort>(
                      value: option,
                      title: Text(switch (option) {
                        _ProductSort.recommended => 'Tavsiya etilgan',
                        _ProductSort.priceLowToHigh => 'Narx: arzonidan',
                        _ProductSort.priceHighToLow => 'Narx: qimmatidan',
                        _ProductSort.rating => 'Reyting bo‘yicha',
                      }),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (selection != null && mounted) setState(() => _sort = selection);
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final categoryId = GoRouterState.of(
      context,
    ).uri.queryParameters['category'];
    final query = GoRouterState.of(context).uri.queryParameters['query'];
    final sourceProducts = ref.watch(
      productsProvider((categoryId: categoryId, query: query)),
    );
    final products = sourceProducts.where((product) {
      return product.priceUzs >= _priceRange.start &&
          product.priceUzs <= _priceRange.end &&
          (!_inStockOnly || product.inStock);
    }).toList();
    switch (_sort) {
      case _ProductSort.recommended:
        break;
      case _ProductSort.priceLowToHigh:
        products.sort((a, b) => a.priceUzs.compareTo(b.priceUzs));
      case _ProductSort.priceHighToLow:
        products.sort((a, b) => b.priceUzs.compareTo(a.priceUzs));
      case _ProductSort.rating:
        products.sort((a, b) => b.rating.compareTo(a.rating));
    }
    final category = MockCatalog.categories.where((c) => c.id == categoryId);
    final title = category.isEmpty ? 'Katalog' : category.first.title;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: BrandHeader(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        query?.isNotEmpty == true ? 'Qidiruv' : title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${products.length} mahsulot',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _FilterHeader(
                onFilter: _showFilterSheet,
                onSort: _showSortSheet,
                sortLabel: _sortLabel,
                isFiltered:
                    _inStockOnly ||
                    _priceRange.start > 0 ||
                    _priceRange.end < 20000000,
              ),
            ),
            if (products.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('Mos mahsulot topilmadi')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 286,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(product: products[index]),
                    childCount: products.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterHeader extends StatelessWidget {
  const _FilterHeader({
    required this.onFilter,
    required this.onSort,
    required this.sortLabel,
    required this.isFiltered,
  });

  final VoidCallback onFilter;
  final VoidCallback onSort;
  final String sortLabel;
  final bool isFiltered;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onFilter,
              icon: Icon(isFiltered ? Icons.filter_alt : Icons.tune, size: 18),
              label: const Text('Filtr'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Tooltip(
              message: sortLabel,
              child: OutlinedButton.icon(
                onPressed: onSort,
                icon: const Icon(Icons.swap_vert, size: 18),
                label: const Text('Saralash'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
