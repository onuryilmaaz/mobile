import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/core/services/storage_service.dart';
import 'package:mobile/features/poll/models/poll_list_dto.dart';
import 'package:mobile/features/poll/models/poll_detail_dto.dart';
import 'package:mobile/features/poll/models/poll_create_dto.dart';
import 'package:mobile/features/poll/models/poll_update_dto.dart';
import 'package:mobile/features/poll/models/poll_response_dto.dart';

class PollService {
  final StorageService _storageService = StorageService();
  final String baseUrl = AppConstants.baseUrl;

  // HTTP header'larını hazırlayan yardımcı method
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Aktif anketleri getir
  Future<List<PollListDto>> getActivePolls() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Poll/active'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PollListDto.fromJson(json)).toList();
      } else {
        throw Exception('Aktif anketler yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Anketler yüklenemedi: $e');
    }
  }

  // Kullanıcının kendi anketlerini getir (Admin)
  Future<List<PollListDto>> getMyPolls() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Poll/my-polls'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PollListDto.fromJson(json)).toList();
      } else {
        throw Exception('Anketleriniz yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Anketleriniz yüklenemedi: $e');
    }
  }

  // Anket detayını getir
  Future<PollDetailDto> getPollById(int pollId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Poll/$pollId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return PollDetailDto.fromJson(json.decode(response.body));
      } else {
        throw Exception('Anket detayı yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Anket detayı yüklenemedi: $e');
    }
  }

  // Anket oluştur (Admin)
  Future<Map<String, dynamic>> createPoll(PollCreateDto pollDto) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Poll/create'),
        headers: await _getHeaders(),
        body: json.encode(pollDto.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return {}; // veya istediğin boş bir Map
        }
      } else {
        throw Exception('Anket oluşturulamadı: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Anket oluşturulamadı: $e');
    }
  }

  // Anket güncelle (Admin)
  Future<Map<String, dynamic>> updatePoll(
    int pollId,
    PollUpdateDto pollDto,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/Poll/update/$pollId'),
        headers: await _getHeaders(),
        body: json.encode(pollDto.toJson()),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Anket güncellenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Anket güncellenemedi: $e');
    }
  }

  // Anket sil (Admin)
  Future<bool> deletePoll(int pollId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/Poll/delete/$pollId'),
        headers: await _getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Anket silinemedi: $e');
    }
  }

  // Anket aktif/pasif durumunu değiştir (Admin)
  Future<bool> togglePoll(int pollId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/Poll/toogle/$pollId'),
        headers: await _getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Anket durumu değiştirilemedi: $e');
    }
  }

  // Anket sonuçlarını getir (Admin)
  Future<Map<String, dynamic>> getPollResults(int pollId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Poll/results/$pollId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Anket sonuçları yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Anket sonuçları yüklenemedi: $e');
    }
  }

  // Anket istatistiklerini getir (Admin)
  Future<Map<String, dynamic>> getPollsSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Poll/summary'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Anket istatistikleri yüklenemedi: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Anket istatistikleri yüklenemedi: $e');
    }
  }

  // Anket cevapla
  Future<bool> submitPollResponse(
    int pollId,
    PollResponseDto responseDto,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Poll/submit/$pollId'),
        headers: await _getHeaders(),
        body: json.encode(responseDto.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Anket yanıtı gönderilemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Anket yanıtı gönderilemedi: $e');
    }
  }
}
