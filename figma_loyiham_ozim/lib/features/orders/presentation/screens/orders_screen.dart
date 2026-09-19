import 'package:flutter/material.dart';

import '../../../../core/widgets/empty_view.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buyurtmalar')),
      body: EmptyView(
        message: "Buyurtmalar hali yo'q — checkout Figma tayyor bo'lgach",
      ),
    );
  }
}
