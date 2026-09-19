import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/data/mock_catalog.dart';

class ProductVideoScreen extends StatelessWidget {
  const ProductVideoScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
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
              child: Icon(Icons.play_circle, color: Colors.white54, size: 72),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.go(AppRoutes.product(productId)),
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
