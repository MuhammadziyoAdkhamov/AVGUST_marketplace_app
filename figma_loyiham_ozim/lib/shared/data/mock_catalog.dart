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
    ShopCategory(id: 'all', title: 'All', icon: Icons.apps),
    ShopCategory(id: 'men', title: 'Erkaklar', icon: Icons.checkroom_outlined),
    ShopCategory(id: 'women', title: 'Ayollar', icon: Icons.woman_outlined),
    ShopCategory(id: 'beauty', title: "Go'zallik", icon: Icons.spa_outlined),
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
    ShopCategory(id: 'sport', title: 'Sportlar', icon: Icons.sports_soccer_outlined),
    ShopCategory(id: 'toys', title: "O'yinchoqlar", icon: Icons.toys_outlined),
    ShopCategory(
      id: 'auto',
      title: 'Avto ehtiyot',
      icon: Icons.directions_car_outlined,
    ),
  ];

  static const products = <Product>[
    Product(
      id: 'p1',
      title: 'Smartfon Redmi A5 3+64GB Ocean blue',
      priceUzs: 3400000,
      categoryId: 'phones',
      rating: 4.9,
      reviewCount: 49,
      sold: 120,
      colors: ['Ocean blue', 'Black'],
      storages: ['64 GB', '128 GB'],
      description:
          'Redmi A5 — kundalik foydalanish uchun qulay, yengil va ishonchli smartfon.',
      specs: {'Ekran': '6.7"', 'Xotira': '64 GB', 'Rang': 'Ocean blue'},
    ),
    Product(
      id: 'p2',
      title: 'Smartfon Xiaomi Redmi 15C 4/256',
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
      title: 'Apple iPhone 14 128GB',
      priceUzs: 7800000,
      categoryId: 'phones',
      rating: 4.9,
      reviewCount: 49,
      colors: ['Blue', 'Red'],
      storages: ['128 GB', '256 GB'],
    ),
    Product(
      id: 'p4',
      title: 'Samsung Galaxy A.556',
      priceUzs: 3000000,
      oldPriceUzs: 3500000,
      categoryId: 'phones',
      rating: 4.9,
      reviewCount: 12,
      sold: 101,
      colors: ['Natural Titanium', 'Black', 'Pink'],
      storages: ['256 GB', '512 GB', '1 TB'],
      sellerName: 'Marketring',
      description:
          "Samsung A.556 — kuchli kamera, uzoq batareya va zamonaviy dizayn.",
      specs: {
        'Brend': 'Samsung',
        'Model': 'A.556',
        'Ekran': '6.5" AMOLED',
        'Kamera': '108 MP',
      },
    ),
    Product(
      id: 'p5',
      title: 'Samsung Galaxy A57 256GB Lilac',
      priceUzs: 3500000,
      categoryId: 'phones',
      rating: 4.6,
      reviewCount: 45,
      colors: ['Lilac'],
      storages: ['256 GB'],
    ),
    Product(
      id: 'p6',
      title: 'Atir gul suvi',
      priceUzs: 280000,
      categoryId: 'beauty',
      rating: 4.5,
      reviewCount: 14,
    ),
    Product(
      id: 'p7',
      title: 'Ulgurji oq idish to\'plami',
      priceUzs: 120000,
      categoryId: 'home',
      wholesale: true,
      rating: 4.4,
    ),
    Product(
      id: 'p8',
      title: 'Ulgurji quti (10 dona)',
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
