// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mobile/core/services/storage_service.dart';
import 'package:mobile/features/poll/model/poll_create.dart';
import 'package:mobile/features/poll/model/poll_model.dart';
import 'package:mobile/features/poll/model/poll_response.dart';
import 'package:mobile/features/poll/model/poll_update.dart';
import 'package:mobile/features/poll/model/polls_response.dart';
import 'package:mobile/features/poll/model/poll_detail.dart';

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

      if (response.statusCode == 201) {
        log('Anket başarıyla oluşturuldu.');
      } else {
        log('Beklenmeyen hata: ${response.statusCode}');
        log('Detay: ${response.data}');
      }
    } catch (e) {
      log('POST işlemi sırasında hata oluştu: $e');
    }
  }

  Future<void> updatePoll(PollUpdate poll) async {
    try {
      final response = await dio.put(
        '$url/update/${poll.id}',
        options: await getHeaders(),
        data: poll.toJson(),
      );
      if (response.statusCode! < 200 && response.statusCode! > 299) {
        throw Exception('Anket güncellenemedi');
      }
    } catch (e) {
      throw Exception('Bir hata oluştu: $e');
    }
  }

  Future<PollDetail> getPoll(int pollId) async {
    try {
      final response = await dio.get(
        '$url/$pollId',
        options: await getHeaders(),
      );
      log('Gelen JSON: ${response.data}');
      if (response.statusCode == 200) {
        // Poll verisini başarılı bir şekilde alırsak
        return PollDetail.fromJson(response.data);
      } else {
        throw Exception('Poll verisi alınamadı');
      }
    } catch (e) {
      throw Exception('Bir hata oluştu: $e');
    }
  }

  Future<List<PollsDetail>> getActivePoll() async {
    List<PollsDetail> pollDetail = [];
    final response = await dio.get("$url/active");

    if (response.statusCode == HttpStatus.ok) {
      final responseData = response.data as List;
      pollDetail =
          responseData.map((poll) => PollsDetail.fromJson(poll)).toList();
    } else {
      throw Exception("Anket detayları yüklenemedi");
    }

    return pollDetail;
  }

  Future<void> togglePollStatus(int pollId) async {
    try {
      await dio.delete("$url/toogle/$pollId", options: await getHeaders());
    } catch (e) {
      throw Exception("Durum güncellenemedi: $e");
    }
  }

  Future<List<PollsResponse>> pollsResponse() async {
    List<PollsResponse> pollsResponse = [];
    final response = await dio.get(
      "$url/my-polls",
      options: await getHeaders(),
    );

    if (response.statusCode == HttpStatus.ok) {
      final responseData = response.data as List;
      pollsResponse =
          responseData.map((poll) => PollsResponse.fromJson(poll)).toList();
    } else {
      throw Exception("Anket detayları yüklenemedi");
    }

    return pollsResponse;
  }

  Future<void> deletePoll(int pollId) async {
    try {
      final response = await dio.delete(
        "$url/delete/$pollId",
        options: await getHeaders(),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        // Anket başarıyla silindi
        return;
      } else {
        throw Exception(response.data["message"] ?? "Anket silinemedi.");
      }
    } catch (e) {
      throw Exception("Anket silinirken bir hata oluştu: $e");
    }
  }

  Future<PollsDetail> getActivePollById(int pollId) async {
    final response = await dio.get('$url/$pollId');
    if (response.statusCode == 200) {
      final json = response.data as Map<String, dynamic>;
      return PollsDetail.fromJson(json);
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
        log('Anket yanıtı başarıyla gönderildi.');
        log("${payload}");
      } else {
        log('Beklenmeyen hata: ${response.statusCode}');
        log('Detay: ${response.data}');
      }
    } catch (e) {
      log('POST işlemi sırasında hata oluştu: $e');
    }
  }
}
