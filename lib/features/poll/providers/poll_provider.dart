import 'package:flutter/foundation.dart';
import 'package:mobile/features/poll/models/poll_list_dto.dart';
import 'package:mobile/features/poll/models/poll_detail_dto.dart';
import 'package:mobile/features/poll/models/poll_create_dto.dart';
import 'package:mobile/features/poll/models/poll_update_dto.dart';
import 'package:mobile/features/poll/models/poll_response_dto.dart';
import 'package:mobile/features/poll/services/poll_service.dart';

class PollProvider with ChangeNotifier {
  final PollService _pollService = PollService();

  // State yönetimi için değişkenler
  bool _isLoading = false;
  String? _errorMessage;
  List<PollListDto>? _activePolls;
  List<PollListDto>? _myPolls;
  PollDetailDto? _currentPoll;
  Map<String, dynamic>? _pollResults;
  Map<String, dynamic>? _pollsSummary;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PollListDto>? get activePolls => _activePolls;
  List<PollListDto>? get myPolls => _myPolls;
  PollDetailDto? get currentPoll => _currentPoll;
  Map<String, dynamic>? get pollResults => _pollResults;
  Map<String, dynamic>? get pollsSummary => _pollsSummary;

  // Aktif anketleri getir
  // Future<void> fetchActivePolls() async {
  //   _setLoading(true);
  //   _clearError();

  //   try {
  //     _activePolls = await _pollService.getActivePolls();
  //     _setLoading(false);
  //   } catch (e) {
  //     _setError(e.toString());
  //   }
  // }

  Future<void> fetchActivePolls() async {
    _setLoading(true);
    _clearError();

    try {
      _activePolls = await _pollService.getActivePolls();
    } catch (e, stacktrace) {
      print('Fetch error: $e');
      print('Stacktrace: $stacktrace');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Kullanıcının kendi anketlerini getir (Admin)
  Future<void> fetchMyPolls() async {
    _setLoading(true);
    _clearError();

    try {
      _myPolls = await _pollService.getMyPolls();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Anket detayını getir
  Future<void> fetchPollById(int pollId) async {
    _setLoading(true);
    _clearError();

    try {
      _currentPoll = await _pollService.getPollById(pollId);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Anket oluştur (Admin)
  Future<bool> createPoll(PollCreateDto pollDto) async {
    _setLoading(true);
    _clearError();

    try {
      await _pollService.createPoll(pollDto);
      await fetchMyPolls(); // Anket listesini yenile
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Anket güncelle (Admin)
  Future<bool> updatePoll(int pollId, PollUpdateDto pollDto) async {
    _setLoading(true);
    _clearError();

    try {
      await _pollService.updatePoll(pollId, pollDto);
      await fetchMyPolls(); // Anket listesini yenile
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Anket sil (Admin)
  Future<bool> deletePoll(int pollId) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _pollService.deletePoll(pollId);
      if (result) {
        if (_myPolls != null) {
          _myPolls!.removeWhere((poll) => poll.id == pollId);
          notifyListeners();
        }
      }
      _setLoading(false);
      return result;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Anket aktif/pasif durumunu değiştir (Admin)
  Future<bool> togglePoll(int pollId) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _pollService.togglePoll(pollId);
      if (result) {
        // Anket listelerini güncelle
        await fetchMyPolls();
      }
      _setLoading(false);
      return result;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Anket sonuçlarını getir (Admin)
  Future<void> fetchPollResults(int pollId) async {
    _setLoading(true);
    _clearError();

    try {
      _pollResults = await _pollService.getPollResults(pollId);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Anket istatistiklerini getir (Admin)
  Future<void> fetchPollsSummary() async {
    _setLoading(true);
    _clearError();

    try {
      _pollsSummary = await _pollService.getPollsSummary();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Anket cevapla
  Future<bool> submitPollResponse(
    int pollId,
    PollResponseDto responseDto,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _pollService.submitPollResponse(pollId, responseDto);
      _setLoading(false);
      return result;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Anket detayını temizle
  void clearCurrentPoll() {
    _currentPoll = null;
    notifyListeners();
  }

  // Yardımcı methodlar
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
