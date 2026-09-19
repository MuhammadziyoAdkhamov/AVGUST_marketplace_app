import 'package:flutter/material.dart';
import 'empty_view.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: EmptyView(message: '$title — Figma tayyor bo\'lgach to\'ldiriladi'),
    );
  }
}
