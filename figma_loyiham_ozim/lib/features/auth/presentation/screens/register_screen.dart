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
  bool _submitting = false;
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool _passwordIsValid(String value) =>
      value.length >= 8 &&
      value.contains(RegExp(r'[A-Z]')) &&
      value.contains(RegExp(r'[0-9]')) &&
      value.contains(RegExp(r'[^A-Za-z0-9]'));

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!_agreed) {
      setState(() => _error = 'Davom etish uchun shartlarga rozilik bering');
      return;
    }
    final identifier = _identifier.text.trim();
    final validEmail = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(identifier);
    final phoneDigits = identifier.replaceAll(RegExp(r'\D'), '');
    if (_phoneTab
        ? phoneDigits.length < 9 || phoneDigits.length > 15
        : !validEmail) {
      setState(
        () => _error = _phoneTab
            ? 'Telefon raqamini to‘g‘ri kiriting'
            : 'Email manzilini to‘g‘ri kiriting',
      );
      return;
    }
    final password = _password.text;
    if (!_passwordIsValid(password)) {
      setState(() => _error = 'Parol barcha talablarni bajarishi kerak');
      return;
    }
    if (_password.text != _confirm.text) {
      setState(() => _error = 'Parollar mos emas');
      return;
    }
    final normalizedIdentifier = _phoneTab
        ? '+${phoneDigits.startsWith('998') ? phoneDigits : '998$phoneDigits'}'
        : identifier;
    setState(() => _submitting = true);
    final result = await ref
        .read(authProvider.notifier)
        .register(
          identifier: normalizedIdentifier,
          isEmail: !_phoneTab,
          password: password,
        );
    if (!mounted) return;
    if (result is Err) {
      setState(() {
        _error = result.failure.message;
        _submitting = false;
      });
      return;
    }
    context.go(AppRoutes.role);
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
              padding: const EdgeInsets.fromLTRB(22, 72, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Ro'yhatdan otish",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Avgustda yangi hisob yarating',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _RegisterTab(
                          icon: Icons.phone,
                          text: 'Telefon raqam orqali',
                          active: _phoneTab,
                          onTap: () => setState(() {
                            _phoneTab = true;
                            _identifier.clear();
                            _error = null;
                          }),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _RegisterTab(
                          icon: Icons.mail,
                          text: 'Email orqali',
                          active: !_phoneTab,
                          onTap: () => setState(() {
                            _phoneTab = false;
                            _identifier.clear();
                            _error = null;
                          }),
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
                    controller: _identifier,
                    keyboardType: _phoneTab
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                    onChanged: (_) => setState(() => _error = null),
                    decoration: InputDecoration(
                      prefixIcon: _phoneTab
                          ? const Padding(
                              padding: EdgeInsets.only(left: 12, right: 8),
                              child: Text(
                                '🇺🇿 +998',
                                style: TextStyle(fontSize: 13),
                              ),
                            )
                          : const Icon(Icons.mail_outline),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      hintText: _phoneTab
                          ? '90 123 45 67'
                          : 'email@example.com',
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
                    onChanged: (_) => setState(() => _error = null),
                    decoration: InputDecoration(
                      hintText: 'Parol kiriting',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
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
                      _Rule('Kamida 8 ta belgi', p.length >= 8),
                      _Rule('Bitta katta harf', p.contains(RegExp(r'[A-Z]'))),
                      _Rule('Bitta raqam', p.contains(RegExp(r'[0-9]'))),
                      _Rule(
                        'Bitta maxsus belgi',
                        p.contains(RegExp(r'[^A-Za-z0-9]')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Parolni tasdiqlang',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 9),
                  TextField(
                    controller: _confirm,
                    obscureText: true,
                    onChanged: (_) => setState(() => _error = null),
                    decoration: const InputDecoration(
                      hintText: 'Parolni qayta kiriting',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
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
                          visualDensity: VisualDensity.compact,
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
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _agreed && !_submitting ? _submit : null,
                      child: _submitting
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Ro'yhatdan o'tish"),
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
          ok ? Icons.check_circle : Icons.circle_outlined,
          color: ok ? const Color(0xff52e87a) : Colors.grey.shade400,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
