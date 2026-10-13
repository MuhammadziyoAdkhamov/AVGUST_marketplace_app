import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/data/mock_catalog.dart';
import '../../../catalog/presentation/widgets/product_card.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});
  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final products = MockCatalog.products
        .where(
          (p) =>
              p.oldPriceUzs != null &&
              p.oldPriceUzs! > p.priceUzs &&
              p.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Aksiyalar')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.list(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4EDC8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YAXSHI NARX, YAXSHI TANLOV',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.2,
                          color: AppColors.brandDark,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Yoqtirganingizni\nqulayroq narxda oling.',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Chegirmali mahsulotlar bir sahifada.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (v) => setState(() => query = v),
                  decoration: const InputDecoration(
                    hintText: 'Aksiyalardan qidirish',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${products.length} ta chegirmali mahsulot',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          if (products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('Mos aksiya topilmadi')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
