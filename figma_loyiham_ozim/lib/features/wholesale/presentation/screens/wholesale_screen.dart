import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/data/mock_catalog.dart';
import '../../../catalog/presentation/widgets/product_card.dart';

class WholesaleScreen extends StatefulWidget {
  const WholesaleScreen({super.key});
  @override
  State<WholesaleScreen> createState() => _WholesaleScreenState();
}

class _WholesaleScreenState extends State<WholesaleScreen> {
  String query = '';
  bool cheapest = true;
  @override
  Widget build(BuildContext context) {
    final products =
        MockCatalog.products
            .where(
              (p) =>
                  p.wholesale &&
                  p.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList()
          ..sort(
            (a, b) => cheapest
                ? a.priceUzs.compareTo(b.priceUzs)
                : b.priceUzs.compareTo(a.priceUzs),
          );
    return Scaffold(
      appBar: AppBar(title: const Text('Ulgurji mahsulotlar')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.list(
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.brandSoft,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.brandDark,
                        size: 32,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Biznesingiz uchun\nfoydali tanlovlar',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Namunaviy narxlar bir dona uchun ko‘rsatilgan. Miqdorni savatda o‘zgartiring.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.brandDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (v) => setState(() => query = v),
                  decoration: const InputDecoration(
                    hintText: 'Ulgurji mahsulot qidirish',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text('${products.length} ta mahsulot')),
                    TextButton.icon(
                      onPressed: () => setState(() => cheapest = !cheapest),
                      icon: const Icon(Icons.swap_vert),
                      label: Text(
                        cheapest ? 'Avval arzonlari' : 'Avval qimmatlari',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('Mos mahsulot topilmadi')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 286,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (_, i) => ProductCard(product: products[i]),
              ),
            ),
        ],
      ),
    );
  }
}
