import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class AppConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://10.210.210.85:8080/api';
    } else if (Platform.isAndroid) {
      return 'http://10.210.210.85:8080/api';
    } else if (Platform.isIOS) {
      return 'http://10.210.210.85:8080/api';
    } else {
      return 'http://10.210.210.85:8080/api';
    }
  }

  static const String tokenKey = 'auth_token';
}

// http://10.210.210.85:8080/api/
