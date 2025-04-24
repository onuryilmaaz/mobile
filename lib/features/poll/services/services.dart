import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mobile/core/services/storage_service.dart';
import 'package:mobile/features/poll/model/poll_create.dart';
import 'package:mobile/features/poll/model/poll_model.dart';
import 'package:mobile/features/poll/model/poll_response.dart';

class Services {
  final dio = Dio();
  final url = "http://10.0.2.2:5231/api/Poll";
  final StorageService _storageService = StorageService();

  Future<Options> getHeaders() async {
    final token = await _storageService.getToken();

    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<void> createPoll(PollCreate poll) async {
    final res = "$url/create";

    try {
      final response = await dio.post(
        res,
        data: poll.toJson(),
        options: await getHeaders(),
      );

      if (response.statusCode == 200) {
        print('Anket başarıyla oluşturuldu.');
      } else {
        print('Beklenmeyen hata: ${response.statusCode}');
        print('Detay: ${response.data}');
      }
    } catch (e) {
      print('POST işlemi sırasında hata oluştu: $e');
    }
  }

  Future<List<PollDetail>> getActivePoll() async {
    List<PollDetail> pollDetail = [];
    final response = await dio.get("$url/active");

    if (response.statusCode == HttpStatus.ok) {
      final responseData = response.data as List;
      pollDetail =
          responseData.map((poll) => PollDetail.fromJson(poll)).toList();
    } else {
      throw Exception("Anket detayları yüklenemedi");
    }

    return pollDetail;
  }

  Future<PollDetail> getActivePollById(int pollId) async {
    final response = await dio.get('$url/$pollId');
    if (response.statusCode == 200) {
      final json = response.data as Map<String, dynamic>;
      return PollDetail.fromJson(json);
    } else {
      throw Exception(
        'Anket detayları alınırken bir hata oluştu: ${response.statusCode}',
      );
    }
  }

  Future<void> submitPollResponse(int pollId, List<AnswerDto> answers) async {
    final res = "$url/submit/$pollId";

    final payload = {
      "answers": answers.map((answer) => answer.toJson()).toList(),
    };

    try {
      final response = await dio.post(
        res,
        data: payload,
        options: await getHeaders(),
      );

      if (response.statusCode == 200) {
        print('Anket yanıtı başarıyla gönderildi.');
        print(payload);
      } else {
        print('Beklenmeyen hata: ${response.statusCode}');
        print('Detay: ${response.data}');
      }
    } catch (e) {
      print('POST işlemi sırasında hata oluştu: $e');
    }
  }
}
