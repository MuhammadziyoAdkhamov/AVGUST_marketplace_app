import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../shared/models/product.dart';
import '../../../catalog/presentation/widgets/product_image.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final count = items.fold(0, (sum, e) => sum + e.qty);
    return Scaffold(
      appBar: AppBar(
        title: Text('Savat${count == 0 ? '' : ' · $count'}'),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              tooltip: 'Savatni tozalash',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final clear = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Savatni tozalaysizmi?'),
                    content: const Text(
                      'Savatdagi barcha mahsulotlar olib tashlanadi.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Bekor qilish'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Tozalash'),
                      ),
                    ],
                  ),
                );
                if (clear == true) ref.read(cartProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.brandSoft,
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 42,
                        color: AppColors.brandDark,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Savatingiz hozircha bo‘sh',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Yoqtirgan mahsulotingizni tanlang.\nQolganini birga davom ettiramiz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => context.go(AppRoutes.catalog),
                      child: const Text('Xaridni boshlash'),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.brandSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.brandDark),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Namoyish rejimi\nHaqiqiy to‘lov va yetkazib berish bajarilmaydi.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...items.map(
                  (item) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 76,
                          height: 102,
                          child: ProductImage(product: item.product),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                [
                                  item.color,
                                  item.storage,
                                ].whereType<String>().join(' · '),
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.product.priceLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Kamaytirish',
                                    onPressed: () => ref
                                        .read(cartProvider.notifier)
                                        .setQty(item.key, item.qty - 1),
                                    icon: Icon(
                                      item.qty == 1
                                          ? Icons.delete_outline
                                          : Icons.remove,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    '${item.qty}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Ko‘paytirish',
                                    onPressed: () => ref
                                        .read(cartProvider.notifier)
                                        .setQty(item.key, item.qty + 1),
                                    icon: const Icon(Icons.add, size: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('Mahsulotlar ($count ta)')),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              '${Product.formatPrice(total)} so‘m',
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      Row(
                        children: [
                          const Text(
                            'Jami',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${Product.formatPrice(total)} so‘m',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    showModalBottomSheet<void>(
                      useRootNavigator: true,
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      builder: (_) => const _Checkout(),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Rasmiylashtirish'),
                ),
              ],
            ),
    );
  }
}

class _Checkout extends ConsumerStatefulWidget {
  const _Checkout();
  @override
  ConsumerState<_Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends ConsumerState<_Checkout> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(),
      _phone = TextEditingController(),
      _address = TextEditingController();
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(ordersProvider.notifier)
          .place(
            List.of(ref.read(cartProvider)),
            '${_name.text.trim()} · ${_phone.text.trim()}\n${_address.text.trim()}',
          );
      ref.read(cartProvider.notifier).clear();
      if (!mounted) return;
      final router = GoRouter.of(context);
      Navigator.pop(context);
      router.go(AppRoutes.orders);
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = 'Saqlashda xatolik. Qayta urinib ko‘ring.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Buyurtmani rasmiylashtirish',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bu namoyish buyurtmasi. Ma’lumotlar faqat shu qurilmada saqlanadi. To‘lov olinmaydi.',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Ismingiz'),
              validator: (v) =>
                  (v?.trim().length ?? 0) < 2 ? 'Ismingizni kiriting' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefon raqami',
                hintText: '+998 90 123 45 67',
              ),
              validator: (v) {
                final d = (v ?? '').replaceAll(RegExp(r'\D'), '');
                return d.length < 9 || d.length > 15
                    ? 'Telefon raqamini tekshiring'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(
                labelText: 'Shahar, ko‘cha va uy',
              ),
              validator: (v) => (v?.trim().length ?? 0) < 6
                  ? 'To‘liq manzilni kiriting'
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              'Jami: ${Product.formatPrice(ref.watch(cartTotalProvider))} so‘m',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: Text(
                _busy ? 'Saqlanmoqda...' : 'Namoyish buyurtmasini saqlash',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
