class RegisterRequest {
  final String email;
  final String password;
  final String fullName;
  // Roller API'nizde isteğe bağlı, şimdilik null bırakılabilir veya eklenebilir
  // final List<String>? roles;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.fullName,
    // this.roles,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fullName': fullName,
      // 'roles': roles, // Gerekirse ekleyin
    };
  }
}
