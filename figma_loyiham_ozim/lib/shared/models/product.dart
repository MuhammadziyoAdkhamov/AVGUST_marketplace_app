class Product {
  const Product({
    required this.id,
    required this.title,
    required this.priceUzs,
    required this.categoryId,
    this.oldPriceUzs,
    this.rating = 4.8,
    this.reviewCount = 0,
    this.sold = 0,
    this.colors = const ['Natural Titanium'],
    this.storages = const ['256 GB'],
    this.sellerName = 'Marketring',
    this.description = '',
    this.specs = const {},
    this.wholesale = false,
    this.inStock = true,
  });

  final String id;
  final String title;
  final int priceUzs;
  final int? oldPriceUzs;
  final String categoryId;
  final double rating;
  final int reviewCount;
  final int sold;
  final List<String> colors;
  final List<String> storages;
  final String sellerName;
  final String description;
  final Map<String, String> specs;
  final bool wholesale;
  final bool inStock;

  String get priceLabel => '${formatPrice(priceUzs)} so\'m';

  static String formatPrice(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final left = s.length - i;
      if (i != 0 && left % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class PromoBanner {
  const PromoBanner({
    required this.title,
    required this.subtitle,
    required this.cta,
  });

  final String title;
  final String subtitle;
  final String cta;
}

class CartItem {
  const CartItem({
    required this.product,
    this.qty = 1,
    this.color,
    this.storage,
  });

  final Product product;
  final int qty;
  final String? color;
  final String? storage;

  int get lineTotal => product.priceUzs * qty;

  CartItem copyWith({int? qty, String? color, String? storage}) {
    return CartItem(
      product: product,
      qty: qty ?? this.qty,
      color: color ?? this.color,
      storage: storage ?? this.storage,
    );
  }
}
