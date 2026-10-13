import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final message = switch (title) {
      'Bildirishnomalar' =>
        'Hozircha yangi bildirishnoma yo‘q. Buyurtmalaringizga oid yangiliklar shu yerda ko‘rinadi.',
      'Xabarlar' =>
        'Hozircha suhbatlar yo‘q. Sotuvchilar bilan yozishish xizmat ishga tushganda mavjud bo‘ladi.',
      'Ilova haqida' =>
        'AVGUST — kundalik xaridlar va ulgurji mahsulotlar uchun ilova.\n\nHozir namoyish versiyasidasiz. Katalog, hisobga kirish va buyurtmalar namunaviy rejimda ishlaydi. Haqiqiy to‘lov olinmaydi.',
      'Yordam markazi' =>
        'Mahsulotni qanday topaman?\nBosh sahifadagi qidiruv yoki kategoriyalardan foydalaning.\n\nBuyurtma qanday beriladi?\nMahsulotni savatga qo‘shing va rasmiylashtirish tugmasini bosing. Namoyish buyurtmalari faqat qurilmangizda saqlanadi.\n\nTo‘lov olinadimi?\nYo‘q. Bu namoyish versiyasi.',
      _ => 'Bu xizmat namoyish versiyasida hali mavjud emas.',
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.brandSoft,
              child: Icon(
                Icons.info_outline_rounded,
                size: 30,
                color: AppColors.brandDark,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(message, style: const TextStyle(fontSize: 16, height: 1.7)),
        ],
      ),
    );
  }
}
