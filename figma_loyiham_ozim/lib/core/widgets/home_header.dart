import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/constants/app_constants.dart';

/// The two-row header used on the home screen.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 20, 20, 18),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 40),
              const Text(
                'Avgust',
                style: TextStyle(
                  fontFamily: 'JotiOne',
                  fontSize: 20,
                  height: 1,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF12CE01),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Xabarlar',
                onPressed: () => context.push(AppRoutes.chat),
                icon: Image.asset(
                  'assets/images/home_screen/messages.png',
                  width: 24,
                  height: 24,
                ),
              ),
              IconButton(
                tooltip: 'Bildirishnomalar',
                onPressed: () => context.push(AppRoutes.notifications),
                icon: Image.asset(
                  'assets/images/home_screen/notification.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 48,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'Kategoriyalar menyusi',
                  onPressed: () => context.push(AppRoutes.allCategories),
                  icon: const Icon(Icons.menu, size: 27, color: Colors.black),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w400,
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(color: Color(0xFFD8D8D8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(color: Color(0xFFD8D8D8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(color: Color(0xFF12CE01)),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 36,
                    ),
                    suffixIcon: IconButton(
                      constraints: const BoxConstraints.tightFor(
                        width: 40,
                        height: 36,
                      ),
                      padding: EdgeInsets.zero,
                      tooltip: 'Ovozli qidiruv',
                      onPressed: () => ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Ovozli qidiruv hali ulanmagan. Qidiruv maydoniga yozishingiz mumkin.',
                            ),
                          ),
                        ),
                      icon: const Icon(
                        Icons.mic_none_rounded,
                        size: 23,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
    ),
  );
}
