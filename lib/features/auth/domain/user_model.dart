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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'role': role.name,
      'reputation': reputation,
      'isActive': isActive,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final roleName = map['role'] as String? ?? 'passenger';

    return UserModel(
      id: map['id'] as String,
      displayName: map['displayName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == roleName,
        orElse: () => UserRole.passenger,
      ),
      reputation: (map['reputation'] as num?)?.toInt() ?? 0,
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}
