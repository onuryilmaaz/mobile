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
    final url = Uri.parse('$_baseUrl/Account');
    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => UserDetail.fromJson(item)).toList();
      } else {
        return []; 
      }
    } catch (e) {
      return [];
    }
  }
  Future<bool> setUserActiveStatus(String userId, bool isActive) async {
    final url = Uri.parse('$_baseUrl/Account/$userId/activate');
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(isActive),
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
