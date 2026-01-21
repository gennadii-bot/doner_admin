class UserModel {
  final int id;
  final String email;
  final String role;
  final bool isActive;
  final String createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'is_active': isActive,
      'created_at': createdAt,
    };
  }
}
