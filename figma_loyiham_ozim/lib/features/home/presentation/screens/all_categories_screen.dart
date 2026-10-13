import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/data/mock_catalog.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = MockCatalog.categories;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 16, 12),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Orqaga',
                      onPressed: () => context.go(AppRoutes.home),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        'Barcha kategoriyalar',
                        style: AppTextStyles.homeHeading,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.catalog),
                      child: const Text('Barchasi'),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              sliver: SliverGrid.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 140,
                  mainAxisExtent: 140,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Semantics(
                    button: true,
                    label: category.title,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => context.go(
                        '${AppRoutes.catalog}?category=${category.id}',
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 86,
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Icon(
                                category.icon,
                                color: const Color(0xFF505050),
                                size: 25,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            category.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, height: 1.1),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
