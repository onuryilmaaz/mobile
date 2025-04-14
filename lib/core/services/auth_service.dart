import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/features/auth/models/auth_response.dart';
import 'package:mobile/features/auth/models/login_request.dart';
import 'package:mobile/features/auth/models/register_request.dart';

class AuthService {
  final String _baseUrl = AppConstants.baseUrl;

  Future<AuthResponse> login(LoginRequest loginRequest) async {
    final url = Uri.parse('$_baseUrl/Account/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(loginRequest.toJson()),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(responseData);
      } else {
        // API'den gelen hata mesajını kullan
        return AuthResponse(
          isSuccess: false,
          message:
              responseData['message'] ??
              'Login failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Ağ hatası vb.
      return AuthResponse(isSuccess: false, message: 'Login failed: $e');
    }
  }

  Future<AuthResponse> register(RegisterRequest registerRequest) async {
    final url = Uri.parse('$_baseUrl/Account/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(registerRequest.toJson()),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(responseData);
      } else {
        // API'den gelen hata mesajını veya detayını kullan
        String errorMessage =
            'Registration failed with status: ${response.statusCode}';
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData is Map && responseData.containsKey('errors')) {
          // Identity'nin detaylı hataları (örneğin şifre politikası)
          try {
            var errors = responseData['errors'] as Map;
            errorMessage = errors.entries
                .map((e) => "${e.key}: ${e.value.join(', ')}")
                .join('\n');
          } catch (_) {
            // Hata formatı beklenenden farklıysa
            errorMessage = jsonEncode(responseData); // Ham yanıtı göster
          }
        } else if (responseData is List) {
          // Bazen hatalar liste olarak dönebilir
          errorMessage = responseData
              .map((e) => e['description'] ?? e.toString())
              .join('\n');
        }
        return AuthResponse(isSuccess: false, message: errorMessage);
      }
    } catch (e) {
      return AuthResponse(isSuccess: false, message: 'Registration failed: $e');
    }
  }
}
