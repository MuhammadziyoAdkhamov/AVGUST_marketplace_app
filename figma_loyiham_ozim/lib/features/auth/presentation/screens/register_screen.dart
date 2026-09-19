import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/error/result.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _phoneTab = true;
  bool _agreed = false;
  bool _hidden = true;
  final _phone = TextEditingController(text: '+998  881353130');
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool _rule(bool v) => v;

  Future<void> _submit() async {
    if (!_agreed) return;
    if (_password.text != _confirm.text) {
      setState(() => _error = 'Parollar mos emas');
      return;
    }
    final result = await ref
        .read(authProvider.notifier)
        .register(phone: _phone.text, password: _password.text);
    if (result is Err && mounted) {
      setState(() => _error = result.failure.message);
      return;
    }
    if (mounted) context.go(AppRoutes.role);
  }

  @override
  Widget build(BuildContext context) {
    final p = _password.text;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 48, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Ro'yhatdan otish",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Avgustda yangi hisob yarating',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _RegisterTab(
                          icon: Icons.phone,
                          text: 'Telefon raqam orqali',
                          active: _phoneTab,
                          onTap: () => setState(() => _phoneTab = true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _RegisterTab(
                          icon: Icons.mail,
                          text: 'Email orqali',
                          active: !_phoneTab,
                          onTap: () => setState(() => _phoneTab = false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    _phoneTab ? 'Telefon raqamingiz' : 'Email pochtangiz',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 9),
                  TextField(
                    controller: _phone,
                    keyboardType: _phoneTab
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: _phoneTab
                          ? const Padding(
                              padding: EdgeInsets.only(left: 12, right: 8),
                              child: Text(
                                '🇹🇷  ▾',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : const Icon(Icons.mail_outline),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Parol yarating',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 9),
                  TextField(
                    controller: _password,
                    obscureText: _hidden,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Parol kiriting',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _hidden = !_hidden),
                        icon: const Icon(Icons.visibility_off_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _Rule('Kamida 8 ta belgi', _rule(p.length >= 8)),
                      _Rule('Bitta katta harf', p.contains(RegExp(r'[A-Z]'))),
                      _Rule('Bitta raqam', p.contains(RegExp(r'[0-9]'))),
                      _Rule(
                        'Bitta maxsus belgi',
                        p.contains(RegExp(r'[^A-Za-z0-9]')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 23),
                  const Text(
                    'Parolni tasdiqlang',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 9),
                  TextField(
                    controller: _confirm,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Parolni qayta kiriting',
                    ),
                  ),
                  const SizedBox(height: 11),
                  InkWell(
                    onTap: () => setState(() => _agreed = !_agreed),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreed,
                          activeColor: AppColors.brandButton,
                          onChanged: (v) =>
                              setState(() => _agreed = v ?? false),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'Men foydalanish shartlari va Maxfiylik siyosati bilan tanishdim',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _agreed ? _submit : null,
                      child: const Text("Ro'yhatdan otish"),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Hisobingiz bormi? '),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.login),
                        child: const Text('Kirish'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterTab extends StatelessWidget {
  const _RegisterTab({
    required this.icon,
    required this.text,
    required this.active,
    required this.onTap,
  });
  final IconData icon;
  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color(0xff50e868) : const Color(0xFFE8FBEB),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: 5),
            Text(text, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule(this.text, this.ok);
  final String text;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          color: ok ? const Color(0xff52e87a) : Colors.grey.shade400,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
