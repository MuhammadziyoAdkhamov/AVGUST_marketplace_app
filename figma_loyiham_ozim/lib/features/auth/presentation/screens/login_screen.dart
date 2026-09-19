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
  bool _remember = false;
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
    final result = await ref
        .read(authProvider.notifier)
        .login(identifier: _id.text, password: _password.text);
    if (result is Err && mounted) {
      setState(() => _error = result.failure.message);
      return;
    }
    if (mounted) context.go(AppRoutes.role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Tizimga kirish',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hisobingizga kiring va davom eting',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                  const SizedBox(height: 38),
                  Row(
                    children: [
                      _LoginType(
                        text: 'Telefon',
                        active: _phoneLogin,
                        onTap: () => setState(() => _phoneLogin = true),
                      ),
                      const SizedBox(width: 8),
                      _LoginType(
                        text: 'Email',
                        active: !_phoneLogin,
                        onTap: () => setState(() => _phoneLogin = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
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
                    decoration: InputDecoration(
                      hintText: _phoneLogin ? '+998 90 123 45 67' : 'email',
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
                          onPressed: () {},
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
                    decoration: InputDecoration(
                      hintText: 'Parolni kiriting',
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
                      onPressed: _submit,
                      child: const Text('Kirish'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text('Hisobingiz yoqmi? '),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.register),
                        child: const Text(
                          "Ro'yhatdan otish",
                          style: TextStyle(color: AppColors.loginBlue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
