import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, color: AppColors.muted),
      ),
    );
  }
}
