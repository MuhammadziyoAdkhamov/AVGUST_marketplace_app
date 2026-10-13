import 'package:flutter/material.dart';
import '../../../../shared/models/product.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/products/${product.id}.webp',
    fit: BoxFit.contain,
    semanticLabel: product.title,
    errorBuilder: (_, error, stack) =>
        const Center(child: Icon(Icons.image_not_supported_outlined, size: 48)),
  );
}
