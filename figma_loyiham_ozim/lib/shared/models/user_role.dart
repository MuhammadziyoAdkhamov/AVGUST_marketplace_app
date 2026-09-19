enum UserRole { buyer, seller, both }

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.buyer => 'Xaridor',
    UserRole.seller => 'Sotuvchi',
    UserRole.both => 'Xaridor va sotuvchi',
  };

  bool get canBuy => this != UserRole.seller;
  bool get canSell => this != UserRole.buyer;
}

/// Both rejimida qaysi panel ochiq.
enum ActiveMode { buyer, seller }
