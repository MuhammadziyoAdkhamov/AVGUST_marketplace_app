import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/local/session_storage.dart';
import '../../../../shared/models/product.dart';

class LocalOrder {
  const LocalOrder({
    required this.id,
    required this.createdAt,
    required this.total,
    required this.summary,
    required this.address,
  });
  final String id, summary, address;
  final DateTime createdAt;
  final int total;
  Map<String, dynamic> toJson() => {
    'id': id,
    'date': createdAt.toIso8601String(),
    'total': total,
    'summary': summary,
    'address': address,
  };
  factory LocalOrder.fromJson(Map<String, dynamic> json) => LocalOrder(
    id: json['id'] as String,
    createdAt: DateTime.parse(json['date'] as String),
    total: json['total'] as int,
    summary: json['summary'] as String,
    address: json['address'] as String,
  );
}

class OrdersNotifier extends Notifier<List<LocalOrder>> {
  @override
  List<LocalOrder> build() {
    final raw = ref
        .read(sharedPreferencesProvider)
        .getString('avgust_demo_orders');
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => LocalOrder.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> place(List<CartItem> items, String address) async {
    if (items.isEmpty) throw StateError('Savat bo‘sh');
    final now = DateTime.now();
    final order = LocalOrder(
      id: now.microsecondsSinceEpoch.toString(),
      createdAt: now,
      total: items.fold(0, (sum, item) => sum + item.lineTotal),
      summary: items
          .map(
            (e) =>
                '${e.product.title} × ${e.qty}${e.storage == null ? '' : ' · ${e.storage}'}${e.color == null ? '' : ' · ${e.color}'}',
          )
          .join('\n'),
      address: address,
    );
    final next = [order, ...state];
    final saved = await ref
        .read(sharedPreferencesProvider)
        .setString(
          'avgust_demo_orders',
          jsonEncode(next.map((e) => e.toJson()).toList()),
        );
    if (!saved) throw StateError('Buyurtmani saqlab bo‘lmadi');
    state = next;
  }
}

final ordersProvider = NotifierProvider<OrdersNotifier, List<LocalOrder>>(
  OrdersNotifier.new,
);
