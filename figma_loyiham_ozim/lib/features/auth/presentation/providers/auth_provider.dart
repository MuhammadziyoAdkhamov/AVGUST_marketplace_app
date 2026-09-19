import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/local/session_storage.dart';
import '../../../../shared/models/app_user.dart';
import '../../../../shared/models/user_role.dart';

class AuthState {
  const AuthState({this.user});

  final AppUser? user;

  bool get isLoggedIn => user != null;
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final user = ref.read(sessionStorageProvider).readUser();
    return AuthState(user: user);
  }

  Future<Result<void>> login({
    required String identifier,
    required String password,
  }) async {
    if (identifier.trim().isEmpty || password.length < 8) {
      return const Err(
        ValidationFailure('Telefon/email va parolni tekshiring'),
      );
    }
    final existing = state.user;
    final user =
        existing ??
        AppUser(
          id: 'u1',
          name: 'Mark Zuckerberg',
          phone: identifier.contains('@') ? '+998 88 135 31 30' : identifier,
          email: identifier.contains('@') ? identifier : 'zucke.net',
          role: UserRole.buyer,
        );
    await ref.read(sessionStorageProvider).saveUser(user);
    state = AuthState(user: user);
    return const Ok(null);
  }

  Future<Result<void>> register({
    required String phone,
    required String password,
  }) async {
    if (phone.trim().isEmpty || password.length < 8) {
      return const Err(ValidationFailure("Ma'lumotlar to'liq emas"));
    }
    final user = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Yangi foydalanuvchi',
      phone: phone,
      role: UserRole.buyer,
    );
    await ref.read(sessionStorageProvider).saveUser(user);
    state = AuthState(user: user);
    return const Ok(null);
  }

  Future<void> setRole(UserRole role) async {
    final user = state.user;
    if (user == null) return;
    final next = user.copyWith(
      role: role,
      activeMode: role == UserRole.seller
          ? ActiveMode.seller
          : ActiveMode.buyer,
    );
    await ref.read(sessionStorageProvider).saveUser(next);
    state = AuthState(user: next);
  }

  Future<void> setActiveMode(ActiveMode mode) async {
    final user = state.user;
    if (user == null) return;
    final next = user.copyWith(activeMode: mode);
    await ref.read(sessionStorageProvider).saveUser(next);
    state = AuthState(user: next);
  }

  Future<void> logout() async {
    await ref.read(sessionStorageProvider).clear();
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
