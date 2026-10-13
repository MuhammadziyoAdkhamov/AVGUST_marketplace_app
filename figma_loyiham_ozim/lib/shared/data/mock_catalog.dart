import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';

class MockCatalog {
  MockCatalog._();

  static const banner = PromoBanner(
    title: 'BIG SALE',
    subtitle: '75% OFF',
    cta: 'SHOP NOW',
  );

  static const categories = <ShopCategory>[
    ShopCategory(id: 'all', title: 'Barcha tovarlar', icon: Icons.apps),
    ShopCategory(id: 'men', title: 'Erkaklar', icon: Icons.checkroom_outlined),
    ShopCategory(id: 'women', title: 'Ayollar', icon: Icons.woman_outlined),
    ShopCategory(
      id: 'construction',
      title: 'Qurilish mollari',
      icon: Icons.handyman_outlined,
    ),
    ShopCategory(
      id: 'accessories',
      title: 'Aksessuarlar',
      icon: Icons.watch_outlined,
    ),
    ShopCategory(
      id: 'phones',
      title: 'Telefonlar',
      icon: Icons.phone_android_outlined,
    ),
    ShopCategory(
      id: 'kids',
      title: 'Bolalar kiyimi',
      icon: Icons.child_care_outlined,
    ),
    ShopCategory(
      id: 'watches',
      title: 'Soatlar',
      icon: Icons.watch_later_outlined,
    ),
    ShopCategory(id: 'toys', title: "O'yinchoqlar", icon: Icons.toys_outlined),
    ShopCategory(id: 'perfumes', title: 'Atirlar', icon: Icons.spa_outlined),
    ShopCategory(
      id: 'auto',
      title: 'Avto tovarlar',
      icon: Icons.directions_car_outlined,
    ),
    ShopCategory(
      id: 'stationery',
      title: 'Kanselyariya',
      icon: Icons.edit_note_outlined,
    ),
    ShopCategory(
      id: 'food',
      title: 'Oziq-ovqat',
      icon: Icons.restaurant_outlined,
    ),
    ShopCategory(
      id: 'sport',
      title: 'Sport tovarlar',
      icon: Icons.sports_soccer_outlined,
    ),
    ShopCategory(
      id: 'music',
      title: 'Musiqa asboblari',
      icon: Icons.music_note_outlined,
    ),
    ShopCategory(id: 'furniture', title: 'Mebel', icon: Icons.weekend_outlined),
    ShopCategory(
      id: 'textile',
      title: 'Tekstil mahsulotlari',
      icon: Icons.checkroom_outlined,
    ),
    ShopCategory(
      id: 'bicycles',
      title: 'Velosipedlar',
      icon: Icons.pedal_bike_outlined,
    ),
    ShopCategory(
      id: 'beauty',
      title: "Go'zallik",
      icon: Icons.face_retouching_natural,
    ),
    ShopCategory(id: 'home', title: "Uy-ro'zg'or", icon: Icons.home_outlined),
  ];

  static const products = <Product>[
    Product(
      id: 'p1',
      title: 'Oppo A57 · 64 GB',
      priceUzs: 3400000,
      categoryId: 'phones',
      rating: 4.9,
      reviewCount: 49,
      sold: 120,
      colors: ['Ocean blue', 'Black'],
      storages: ['64 GB', '128 GB'],
      description:
          'Oppo A57 — kundalik foydalanish uchun qulay, yengil va ishonchli smartfon.',
      specs: {'Ekran': '6.7"', 'Xotira': '64 GB', 'Rang': 'Ocean blue'},
    ),
    Product(
      id: 'p2',
      title: 'Realme C35 · 128 GB',
      priceUzs: 3400000,
      categoryId: 'phones',
      rating: 4.7,
      reviewCount: 80,
      sold: 210,
      colors: ['Black', 'Blue'],
      storages: ['256 GB'],
    ),
    Product(
      id: 'p3',
      title: 'Apple iPhone 13 Pro · 128 GB',
      priceUzs: 7800000,
      oldPriceUzs: 8500000,
      categoryId: 'phones',
      rating: 4.9,
      reviewCount: 49,
      colors: ['Blue', 'Red'],
      storages: ['128 GB', '256 GB'],
    ),
    Product(
      id: 'p4',
      title: 'Samsung Galaxy S10 · 128 GB',
      priceUzs: 3000000,
      oldPriceUzs: 3500000,
      categoryId: 'phones',
      rating: 4.9,
      reviewCount: 12,
      sold: 101,
      colors: ['Natural Titanium', 'Black', 'Pink'],
      storages: ['128 GB'],
      sellerName: 'Avgust Market',
      description:
          "Samsung Galaxy S10 — kuchli kamera, uzoq batareya va zamonaviy dizayn.",
      specs: {
        'Brend': 'Samsung',
        'Model': 'Galaxy S10',
        'Ekran': '6.1" AMOLED',
        'Katalog': 'Namoyish mahsuloti',
      },
    ),
    Product(
      id: 'p5',
      title: 'Vivo S1 · 128 GB',
      priceUzs: 3500000,
      categoryId: 'phones',
      rating: 4.6,
      reviewCount: 45,
      colors: ['Lilac'],
      storages: ['256 GB'],
    ),
    Product(
      id: 'p6',
      title: 'Calvin Klein CK One',
      priceUzs: 280000,
      oldPriceUzs: 340000,
      categoryId: 'beauty',
      rating: 4.5,
      reviewCount: 14,
    ),
    Product(
      id: 'p7',
      title: 'Alyuminiy finjon',
      priceUzs: 120000,
      categoryId: 'home',
      wholesale: true,
      rating: 4.4,
    ),
    Product(
      id: 'p8',
      title: 'Bambuk oshxona kurakchasi',
      priceUzs: 89000,
      categoryId: 'home',
      wholesale: true,
    ),
  ];

  static List<Product> byCategory(String? categoryId) {
    if (categoryId == null || categoryId == 'all') return products;
    return products.where((p) => p.categoryId == categoryId).toList();
  }

  static Product? byId(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }
}
