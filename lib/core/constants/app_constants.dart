import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class AppConstants {
  // API'nizin çalıştığı temel URL'yi buraya girin
  // Dikkat:
  // 1. Android Emulator için localhost yerine '10.0.2.2' kullanın.
  // 2. iOS Simulator ve fiziksel cihazlar için bilgisayarınızın yerel IP adresini kullanın (örn: '192.168.1.100').
  // 3. Web için 'localhost' veya IP adresi genellikle çalışır.
  // 4. API'niz HTTPS kullanıyorsa 'https://' ile başlatın. Geliştirme sırasında sertifika sorunları olabilir.
  // 5. API canlıya çıktığında gerçek sunucu adresini kullanın.

  static String get baseUrl {
    if (kIsWeb) {
      // Flutter Web için (API aynı makinede çalışıyorsa)
      return 'http://localhost:5231/api'; // Port numarasını kendi API'nize göre değiştirin
    } else if (Platform.isAndroid) {
      // Android Emulator
      return 'http://10.0.2.2:5231/api'; // Port numarasını kendi API'nize göre değiştirin
    } else if (Platform.isIOS) {
      // iOS Simulator/Fiziksel Cihaz (Bilgisayarınızın IP'si)
      // return 'http://192.168.1.100:5000/api'; // Kendi IP adresiniz ve portunuzla değiştirin
      return 'http://localhost:5231/api'; // Veya Mac üzerinde localhost deneyebilirsiniz.
    } else {
      // Diğer platformlar (Desktop vb.)
      return 'http://localhost:5231/api'; // Port numarasını kendi API'nize göre değiştirin
    }
  }

  // Token'ı saklamak için kullanılacak anahtar
  static const String tokenKey = 'auth_token';
}
