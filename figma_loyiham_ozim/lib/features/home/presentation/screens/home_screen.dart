import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/brand_header.dart';
import '../../../../shared/data/mock_catalog.dart';
import '../../../catalog/presentation/widgets/product_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final categories = MockCatalog.categories;
    final recommended = MockCatalog.products.take(4).toList();
    final wholesale = MockCatalog.products.where((p) => p.wholesale).toList();
    final suggestions = _query.trim().isEmpty
        ? const <String>[]
        : MockCatalog.products
              .where(
                (product) => product.title.toLowerCase().contains(
                  _query.trim().toLowerCase(),
                ),
              )
              .map((product) => product.title)
              .take(4)
              .toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 8, 0),
                child: BrandHeader(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) => setState(() => _query = value),
                      onSubmitted: (_) => context.go(AppRoutes.catalog),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.menu),
                        suffixIcon: Icon(Icons.mic_none),
                        isDense: true,
                      ),
                    ),
                    if (suggestions.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            for (final suggestion in suggestions)
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                title: Text(
                                  suggestion,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                onTap: () => context.go(AppRoutes.catalog),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    Container(
                      height: 122,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 14, 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffd898da), Color(0xfff7a37d)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            MockCatalog.banner.title,
                            style: const TextStyle(
                              fontSize: 23,
                              color: Color(0xff4e4dc0),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            MockCatalog.banner.subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          OutlinedButton(
                            onPressed: () => context.go(AppRoutes.catalog),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(78, 26),
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                            ),
                            child: Text(
                              MockCatalog.banner.cta,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Categorylar',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = categories[index];
                  return InkWell(
                    onTap: () =>
                        context.go('${AppRoutes.catalog}?category=${item.id}'),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xfff2f5f3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            item.icon,
                            color: const Color(0xff707b73),
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 9),
                        ),
                      ],
                    ),
                  );
                }, childCount: categories.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.72,
                  mainAxisSpacing: 8,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Ulgurji mahsulotlar',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.wholesale),
                          child: const Text(
                            'Barchasi >',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 168,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: wholesale.isEmpty ? 2 : wholesale.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 9),
                        itemBuilder: (_, index) {
                          if (wholesale.isEmpty) {
                            return const SizedBox(width: 105);
                          }
                          return SizedBox(
                            width: 140,
                            child: ProductCard(product: wholesale[index]),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tavsiya etilgan mahsulotlar',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommended.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 9),
                        itemBuilder: (_, index) => SizedBox(
                          width: 160,
                          child: ProductCard(product: recommended[index]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.brandSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Xiaomi mahsulotlariga',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '20% chegirma',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                          FilledButton(
                            onPressed: () => context.go(AppRoutes.catalog),
                            child: const Text('Ko\'rish'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
