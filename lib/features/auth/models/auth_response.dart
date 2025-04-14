class AuthResponse {
  final bool isSuccess;
  final String? token;
  final String message;

  AuthResponse({required this.isSuccess, this.token, required this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      isSuccess: json['isSuccess'] ?? false,
      token: json['token'], // Token null olabilir
      message: json['message'] ?? 'An error occurred',
    );
  }
}
