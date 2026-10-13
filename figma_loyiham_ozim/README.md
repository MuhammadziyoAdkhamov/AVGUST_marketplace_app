# AVGUST namoyish ilovasi

Flutter / Riverpod / GoRouter asosidagi xarid ilovasi.

## Ishga tushirish

`flutter pub get`
`flutter run -d chrome`

Kirish sahifasida **Namoyishni ochish** tugmasi orqali ko‘ring.

## Mavjud jarayonlar

- Mahsulot va kategoriya qidiruvi, narx / reyting bo‘yicha saralash va narx filtri.
- Mahsulot tafsilotlari, variant tanlash, sevimlilar va savat miqdorlari.
- Aksiyalar va ulgurji katalogda qidiruv.
- Ism, telefon, manzil tekshiruvi va qurilmada saqlanadigan namoyish buyurtmalari.
- Ro‘yxatdan o‘tish, rol tanlash va profil uchun mahalliy namoyish oqimi.

## Namoyish chegaralari

Haqiqiy autentifikatsiya, SMS/OTP, server, to‘lov, yetkazib berish, sotuvchi kabineti va xabar almashish ulanmagan. Hozirgi login haqiqiy parolni serverda tekshirmaydi. Buyurtmalar SharedPreferences orqali shu qurilmada saqlanadi va sotuvchiga yuborilmaydi. Savat va sevimlilar sessiya davomida ishlaydi. Videolar mavjud emas.

Katalog ma’lumotlari, variantlar va narxlar namuna hisoblanadi. Mahsulot fotosuratlari DummyJSON namoyish katalogidan mahalliy `assets/images/products/` papkasiga saqlandi: https://dummyjson.com/products. p1: Oppo A57, p2: Realme C35, p3: iPhone 13 Pro, p4: Samsung Galaxy S10, p5: Vivo S1, p6: Calvin Klein CK One, p7: Black Aluminium Cup, p8: Bamboo Spatula. Ishlab chiqarish versiyasida tasdiqlangan mahsulot ma’lumotlari va foydalanish huquqi bor rasmlar bilan almashtiriladi.

## Tekshirish

`flutter analyze`
`flutter test`
`flutter build web --no-wasm-dry-run`

Testlar ichida 390px telefon ekranida namoyishdan buyurtmagacha to‘liq oqim ham mavjud.
