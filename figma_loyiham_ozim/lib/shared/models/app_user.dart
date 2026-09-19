import 'user_role.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.role,
    this.activeMode = ActiveMode.buyer,
  });

  final String id;
  final String name;
  final String phone;
  final String? email;
  final UserRole role;
  final ActiveMode activeMode;

  AppUser copyWith({
    String? name,
    String? phone,
    String? email,
    UserRole? role,
    ActiveMode? activeMode,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      activeMode: activeMode ?? this.activeMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'role': role.name,
    'activeMode': activeMode.name,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      role: UserRole.values.byName(json['role'] as String),
      activeMode: ActiveMode.values.byName(
        json['activeMode'] as String? ?? 'buyer',
      ),
    );
  }
}
