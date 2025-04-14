class UserDetail {
  final String id;
  final String? fullName;
  final String? email;
  final List<String> roles;
  final bool isActive; // API'den gelen IsActive alanı

  UserDetail({
    required this.id,
    this.fullName,
    this.email,
    required this.roles,
    required this.isActive,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'] ?? '',
      fullName: json['fullName'],
      email: json['email'],
      roles: List<String>.from(json['roles'] ?? []),
      isActive: json['isActive'] ?? false, // API'den gelen değere göre
    );
  }
}
