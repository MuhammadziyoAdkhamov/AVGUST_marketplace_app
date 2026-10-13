import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/data/mock_catalog.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

class ProductVideoScreen extends ConsumerWidget {
  const ProductVideoScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = MockCatalog.byId(productId);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(product?.title ?? 'Video'),
      ),
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.videocam_off_outlined,
                    color: Colors.white54,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Bu mahsulot uchun video hali qo‘shilmagan',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: product == null
                    ? null
                    : () {
                        ref.read(cartProvider.notifier).add(product);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text("Savatchaga qo'shildi"),
                            ),
                          );
                      },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text("Savatchaga qo'shish"),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brandButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
