import 'package:flutter/foundation.dart';
import 'package:mobile/core/services/auth_service.dart'; // Yolu düzeltin
import 'package:mobile/core/services/storage_service.dart';
import 'package:mobile/core/services/user_service.dart';
import 'package:mobile/features/auth/models/auth_response.dart';
import 'package:mobile/features/auth/models/login_request.dart';
import 'package:mobile/features/auth/models/register_request.dart';
import 'package:mobile/features/user/models/user_detail.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  final UserService _userService =
      UserService(); // Kullanıcı detayını çekmek için

  String? _token;
  UserDetail? _userDetail;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false; // Eklendi

  String? get token => _token;
  UserDetail? get userDetail => _userDetail;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAdmin => _userDetail?.roles.contains('Admin') ?? false;
  bool get isInitialized => _isInitialized; // Eklendi

  AuthProvider() {
    _loadToken(); // Uygulama başlarken token'ı yüklemeyi dene
  }

  Future<void> _loadToken() async {
    _setLoading(true);
    _token = await _storageService.getToken();
    if (isAuthenticated) {
      await fetchUserDetails(); // Token varsa kullanıcı detaylarını çek
    }
    _isInitialized = true; // Token yükleme tamamlandı
    _setLoading(false);
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    final request = LoginRequest(email: email, password: password);
    final AuthResponse response = await _authService.login(request);

    if (response.isSuccess && response.token != null) {
      _token = response.token;
      await _storageService.saveToken(_token!);
      await fetchUserDetails(); // Başarılı login sonrası kullanıcı detaylarını çek
      _setLoading(false);
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String email, String password, String fullName) async {
    _setLoading(true);
    _clearError();

    final request = RegisterRequest(
      email: email,
      password: password,
      fullName: fullName,
    );
    final AuthResponse response = await _authService.register(request);

    if (response.isSuccess) {
      _errorMessage = "Kayıt başarılı! Lütfen giriş yapın."; // Başarı mesajı
      _setLoading(false);
      notifyListeners(); // Hata mesajını göstermek için state'i güncelle
      return true;
    } else {
      _errorMessage = response.message;
      _setLoading(false);
      return false;
    }
  }

  Future<void> fetchUserDetails() async {
    // Token yoksa veya zaten yükleniyorsa işlem yapma
    if (!isAuthenticated || _isLoading) return;

    _setLoading(true); // Kullanıcı detayı çekilirken de loading olabilir
    _userDetail = await _userService.getUserDetail();
    // Eğer detay çekilemezse (token geçersiz vs), logout yapabiliriz
    if (_userDetail == null && isAuthenticated) {
      await logout(); // Otomatik logout
    }
    _setLoading(false); // Loading bitti
    // notifyListeners(); // _setLoading zaten çağırıyor
  }

  Future<void> logout() async {
    _token = null;
    _userDetail = null;
    await _storageService.deleteToken();
    notifyListeners();
  }

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

  void clearErrorMessage() {
    // Public metot
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
