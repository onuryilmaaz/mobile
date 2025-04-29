import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/core/services/storage_service.dart';
import 'package:mobile/features/user/models/user_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final String _baseUrl = AppConstants.baseUrl;
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};

    if (token != null && token.isNotEmpty) {
      // Kullanıcı login olmuşsa
      headers['Authorization'] = 'Bearer $token';
    } else {
      // Kullanıcı login değilse
      final sessionId = await _getSessionId();
      headers['SessionId'] = sessionId;
    }

    return headers;
  }

  Future<String> _getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('SessionId');

    if (sessionId == null) {
      sessionId = Uuid().v4();
      await prefs.setString('SessionId', sessionId);
    }

    return sessionId;
  }

  Future<UserDetail?> getUserDetail() async {
    final url = Uri.parse('$_baseUrl/Account/detail');
    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return UserDetail.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
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
        return []; // Hata durumunda boş liste dön
      }
    } catch (e) {
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
