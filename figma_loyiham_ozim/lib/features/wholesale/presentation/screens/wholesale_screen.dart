import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/brand_header.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../catalog/presentation/widgets/product_card.dart';
import '../../../catalog/presentation/providers/catalog_provider.dart';

class WholesaleScreen extends ConsumerStatefulWidget {
  const WholesaleScreen({super.key});

  @override
  ConsumerState<WholesaleScreen> createState() => _WholesaleScreenState();
}

class _WholesaleScreenState extends ConsumerState<WholesaleScreen> {
  int amount = 10;

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(wholesaleProductsProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandHeader(),
              const SizedBox(height: 12),
              const Text(
                'Ulgurji mahsulotlar',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: Icon(Icons.mic_none),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SellerType('Fabrikadan'),
                  _SellerType('Distribyutor'),
                  _SellerType('Importyor'),
                  _SellerType('Verified'),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Minimal buyurtma (MQQ)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [10, 50, 100, 500, 1000]
                    .map(
                      (v) => ChoiceChip(
                        label: Text('$v dona'),
                        selected: amount == v,
                        selectedColor: const Color(0xff85ef8c),
                        onSelected: (_) => setState(() => amount = v),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_Drop('Category'), _Drop('Filtr'), _Drop('Saralash')],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: products.isEmpty
                    ? const EmptyView(message: 'Ulgurji mahsulotlar topilmadi')
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) =>
                            ProductCard(product: products[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SellerType extends StatelessWidget {
  const _SellerType(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffdedede)),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 7),
        Text(text, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class _Drop extends StatelessWidget {
  const _Drop(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Text('$text  ⌄', style: const TextStyle(fontSize: 11)),
    );
  }
}
