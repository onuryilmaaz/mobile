import 'package:flutter/foundation.dart';
import 'package:mobile/core/services/user_service.dart'; // Yolu düzeltin
import 'package:mobile/features/user/models/user_detail.dart'; // Yolu düzeltin

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  List<UserDetail> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserDetail> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _userService.getAllUsers();
    } catch (e) {
      _errorMessage = "Kullanıcılar getirilirken hata: $e";
      _users = []; // Hata durumunda listeyi boşalt
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleUserStatus(String userId, bool currentIsActive) async {
    // Kullanıcı arayüzünü hemen güncelleyebiliriz (iyimser güncelleme)
    // veya API çağrısı bitene kadar bekleyebiliriz. Şimdilik bekleyelim.

    // API'ye gönderilecek yeni durum (API'nin !isActive mantığına göre)
    // Eğer API'yi user.IsActive = isActive; olarak düzelttiyseniz:
    // bool newStatusApi = !currentIsActive;
    // Eğer API'yi düzeltmediyseniz (user.IsActive = !isActive; ise):
    bool newStatusApi =
        currentIsActive; // API zaten tersini alacağı için mevcut durumu gönder

    bool success = await _userService.setUserActiveStatus(userId, newStatusApi);

    if (success) {
      // Başarılı olursa listeyi yenile
      await fetchUsers();
      return true;
    } else {
      // Hata durumunda kullanıcıya bilgi verilebilir (örn: SnackBar)
      _errorMessage = "Kullanıcı durumu güncellenemedi.";
      notifyListeners(); // Hata mesajını göstermek için
      return false;
    }
  }
}
