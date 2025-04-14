import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/core/services/storage_service.dart';
import 'package:mobile/features/user/models/user_detail.dart';

class UserService {
  final String _baseUrl = AppConstants.baseUrl;
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<UserDetail?> getUserDetail() async {
    final url = Uri.parse('$_baseUrl/Account/detail');
    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return UserDetail.fromJson(jsonDecode(response.body));
      } else {
        print(
          'Failed to get user detail: ${response.statusCode} ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('Error getting user detail: $e');
      return null;
    }
  }

  Future<List<UserDetail>> getAllUsers() async {
    final url = Uri.parse('$_baseUrl/Account'); // GET isteği
    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => UserDetail.fromJson(item)).toList();
      } else {
        print('Failed to get users: ${response.statusCode} ${response.body}');
        return []; // Hata durumunda boş liste dön
      }
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  // Dikkat: API kodunuzda user.IsActive = !isActive; yazıyor.
  // Bu, gönderilen isActive değerinin TERSİNİ atar.
  // Eğer API'nin amacı gönderilen değere EŞİTLEMEK ise, API kodunu user.IsActive = isActive; olarak düzeltin.
  // Buradaki Flutter kodu, API'nin gönderilen değere EŞİTLEDİĞİNİ varsayıyor.
  Future<bool> setUserActiveStatus(String userId, bool isActive) async {
    final url = Uri.parse('$_baseUrl/Account/$userId/activate');
    try {
      final headers = await _getHeaders();
      // PUT isteğinin body'sine doğrudan boolean değeri JSON olarak gönderiyoruz
      // Önemli: API'nizin [FromBody] bool isActive parametresini doğru işlemesi gerekir.
      // Eğer API basit bir boolean bekliyorsa bu çalışır.
      // Eğer bir JSON nesnesi ({ "isActive": true }) bekliyorsa body'yi ona göre ayarlayın.
      // API kodunuz sadece [FromBody] bool isActive dediği için bu yeterli olmalı.
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(isActive), // Doğrudan boolean'ı JSON'a çevir
      );

      if (response.statusCode == 200) {
        print('User status updated successfully.');
        return true;
      } else {
        print(
          'Failed to update user status: ${response.statusCode} ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Error updating user status: $e');
      return false;
    }
  }
}
