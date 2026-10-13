import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/product.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void add(Product product, {String? color, String? storage}) {
    final i = state.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.color == color &&
          item.storage == storage,
    );
    if (i >= 0) {
      final copy = [...state];
      copy[i] = copy[i].copyWith(qty: copy[i].qty + 1);
      state = copy;
      return;
    }
    state = [
      ...state,
      CartItem(product: product, color: color, storage: storage),
    ];
  }

  void setQty(String itemKey, int qty) {
    if (qty <= 0) {
      remove(itemKey);
      return;
    }
    state = [
      for (final item in state)
        if (item.key == itemKey) item.copyWith(qty: qty) else item,
    ];
  }

  void remove(String itemKey) {
    state = state.where((item) => item.key != itemKey).toList();
  }

  void clear() => state = [];

  int get total => state.fold(0, (sum, e) => sum + e.lineTotal);
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

final cartTotalProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(0, (sum, e) => sum + e.lineTotal);
});
