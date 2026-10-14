enum UserRole { passenger, admin }

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final UserRole role;
  final int reputation;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.role = UserRole.passenger,
    this.reputation = 0,
    this.isActive = true,
  });
}
