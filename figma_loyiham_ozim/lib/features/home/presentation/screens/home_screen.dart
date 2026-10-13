import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/home_header.dart';
import '../../../../shared/data/mock_catalog.dart';
import '../../../catalog/presentation/widgets/product_card.dart';
import '../../../catalog/presentation/widgets/product_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  String _query = '';
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = [
      ...MockCatalog.products
          .where((p) => p.title.toLowerCase().contains(_query.toLowerCase()))
          .map((p) => (p.title, AppRoutes.product(p.id))),
      ...MockCatalog.categories
          .where((c) => c.title.toLowerCase().contains(_query.toLowerCase()))
          .map((c) => (c.title, '${AppRoutes.catalog}?category=${c.id}')),
    ];
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeader(
                controller: _search,
                onChanged: (value) => setState(() => _query = value),
                onSubmitted: (_) => context.go(
                  '${AppRoutes.catalog}?${Uri(queryParameters: {'query': _query.trim()}).query}',
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.list(
                children: [
                  if (_query.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: results.isEmpty
                            ? [
                                const ListTile(
                                  title: Text('Mos mahsulot topilmadi'),
                                ),
                              ]
                            : results
                                  .take(5)
                                  .map(
                                    (r) => ListTile(
                                      leading: const Icon(
                                        Icons.search,
                                        size: 20,
                                      ),
                                      title: Text(r.$1),
                                      trailing: const Icon(
                                        Icons.north_west,
                                        size: 16,
                                      ),
                                      onTap: () => context.push(r.$2),
                                    ),
                                  )
                                  .toList(),
                      ),
                    ),
                  const SizedBox(height: 22),
                  const _HeroOffer(),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickLink(
                          icon: Icons.local_offer_outlined,
                          label: 'Aksiyalar',
                          color: const Color(0xFFF0E6D4),
                          onTap: () => context.push(AppRoutes.promotions),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickLink(
                          icon: Icons.inventory_2_outlined,
                          label: 'Ulgurji xarid',
                          color: AppColors.brandSoft,
                          onTap: () => context.push(AppRoutes.wholesale),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _SectionTitle(
                    title: 'Kategoriyalar',
                    onTap: () => context.push(AppRoutes.allCategories),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) => Wrap(
                      spacing: 8,
                      runSpacing: 14,
                      children: MockCatalog.categories
                          .take(10)
                          .map(
                            (c) => SizedBox(
                              width: (constraints.maxWidth - 32) / 5,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => context.go(
                                  '${AppRoutes.catalog}?category=${c.id}',
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 56,
                                      width: 56,
                                      decoration: BoxDecoration(
                                        color: c.id == 'all'
                                            ? AppColors.brandButton
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Icon(
                                        c.icon,
                                        color: c.id == 'all'
                                            ? Colors.white
                                            : AppColors.brandDark,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      c.title,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        height: 1.25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 26),
                  _SectionTitle(
                    title: 'Siz uchun tanladik',
                    onTap: () => context.go(AppRoutes.catalog),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) => SliverGrid.builder(
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.crossAxisExtent > 600 ? 4 : 2,
                    mainAxisExtent: 286,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) =>
                      ProductCard(product: MockCatalog.products[index]),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EDE4),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.storefront_outlined,
                      size: 36,
                      color: AppColors.brandDark,
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Biznes uchun ham qulay',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Ulgurji mahsulotlarni kashf eting.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Ulgurji mahsulotlar',
                      onPressed: () => context.push(AppRoutes.wholesale),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  'Namoyish katalogi · Narxlar va mahsulotlar misol tariqasida.',
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroOffer extends StatelessWidget {
  const _HeroOffer();
  @override
  Widget build(BuildContext context) => Container(
    height: 205,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: const Color(0xFF143D2B),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Stack(
      children: [
        Positioned(
          right: -28,
          top: -35,
          child: Container(
            width: 205,
            height: 255,
            decoration: const BoxDecoration(
              color: Color(0xFF284F38),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: -6,
          bottom: 8,
          width: 145,
          height: 178,
          child: Transform.rotate(
            angle: .12,
            child: ProductImage(product: MockCatalog.products[3]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AVGUST TANLOVI',
                style: TextStyle(
                  color: Color(0xFFBDEDA3),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Yangi telefon.\nYangi imkoniyatlar.',
                style: TextStyle(
                  fontSize: 20,
                  height: 1.12,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.5,
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFD6EDA7),
                  foregroundColor: AppColors.text,
                  minimumSize: const Size(0, 38),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                onPressed: () =>
                    context.go('${AppRoutes.catalog}?category=phones'),
                label: const Text(
                  'Ko‘rib chiqish',
                  style: TextStyle(fontSize: 12),
                ),
                icon: const Icon(Icons.arrow_forward, size: 16),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: color,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 11),
          ],
        ),
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -.5,
          ),
        ),
      ),
      TextButton(
        onPressed: onTap,
        child: const Text('Barchasi', style: TextStyle(fontSize: 12)),
      ),
    ],
  );
}
