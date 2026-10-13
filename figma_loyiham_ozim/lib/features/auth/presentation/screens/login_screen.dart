import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/error/result.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _phoneLogin = false;
  bool _remember = true;
  bool _submitting = false;
  bool _hidden = true;
  final _id = TextEditingController();
  final _password = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final identifier = _id.text.trim();
    final emailValid = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(identifier);
    final phoneDigits = identifier.replaceAll(RegExp(r'\D'), '');
    final identityValid = _phoneLogin
        ? phoneDigits.length >= 9 && phoneDigits.length <= 15
        : emailValid;
    if (!identityValid) {
      setState(
        () => _error = _phoneLogin
            ? 'Telefon raqamini to‘g‘ri kiriting'
            : 'Email manzilini to‘g‘ri kiriting',
      );
      return;
    }
    if (_password.text.length < 8) {
      setState(
        () => _error = 'Parol kamida 8 ta belgidan iborat bo‘lishi kerak',
      );
      return;
    }
    setState(() {
      _error = null;
      _submitting = true;
    });
    final result = await ref
        .read(authProvider.notifier)
        .login(
          identifier: identifier,
          password: _password.text,
          remember: _remember,
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
                    'avgust.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                      color: AppColors.brandDark,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Tizimga kirish',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hisobingizga kiring va davom eting',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 38),
                  Row(
                    children: [
                      _LoginType(
                        text: 'Telefon',
                        active: _phoneLogin,
                        onTap: () => setState(() {
                          _phoneLogin = true;
                          _id.clear();
                          _error = null;
                        }),
                      ),
                      const SizedBox(width: 8),
                      _LoginType(
                        text: 'Email',
                        active: !_phoneLogin,
                        onTap: () => setState(() {
                          _phoneLogin = false;
                          _id.clear();
                          _error = null;
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    _phoneLogin ? 'Telefon raqamingiz' : 'Email pochtangiz',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 9),
                  TextField(
                    controller: _id,
                    keyboardType: _phoneLogin
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                    onChanged: (_) => setState(() => _error = null),
                    decoration: InputDecoration(
                      hintText: _phoneLogin ? '+998 90 123 45 67' : 'email',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Text(
                        'Parol',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Flexible(
                        child: TextButton(
                          onPressed: () => ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Parolni tiklash serverga ulangach ishlaydi.',
                                ),
                              ),
                            ),
                          child: const Text(
                            'Parolni unutdingizmi ?',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.loginBlue),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _password,
                    obscureText: _hidden,
                    onChanged: (_) => setState(() => _error = null),
                    decoration: InputDecoration(
                      hintText: 'Parolni kiriting',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _hidden = !_hidden),
                        icon: Icon(
                          _hidden
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => setState(() => _remember = !_remember),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _remember,
                          activeColor: AppColors.brandButton,
                          visualDensity: VisualDensity.compact,
                          onChanged: (value) =>
                              setState(() => _remember = value ?? false),
                        ),
                        const Text(
                          'Meni eslab qol',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.loginBlue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Kirish'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text('Hisobingiz yo‘qmi? '),
                      TextButton(
                        onPressed: _submitting
                            ? null
                            : () => context.go(AppRoutes.register),
                        child: const Text(
                          "Ro‘yxatdan o‘tish",
                          style: TextStyle(color: AppColors.loginBlue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _submitting
                        ? null
                        : () async {
                            await ref
                                .read(authProvider.notifier)
                                .login(
                                  identifier: 'demo@avgust.local',
                                  password: 'DemoOnly1!',
                                  remember: false,
                                );
                            if (context.mounted) context.go(AppRoutes.home);
                          },
                    icon: const Icon(Icons.explore_outlined),
                    label: const Text('Namoyishni ochish'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Namoyish rejimi · Haqiqiy hisobga kirish va to‘lov uchun server ulanishi kerak.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: AppColors.muted),
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

class _LoginType extends StatelessWidget {
  const _LoginType({
    required this.text,
    required this.active,
    required this.onTap,
  });
  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 36,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: active
                ? AppColors.loginBlue
                : AppColors.loginBlueSoft,
            foregroundColor: active ? Colors.white : AppColors.loginBlue,
          ),
          onPressed: onTap,
          child: Text(text),
        ),
      ),
    );
  }
}
