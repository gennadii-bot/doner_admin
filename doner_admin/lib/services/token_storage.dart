// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../config/app_config.dart';

// class TokenStorage {
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();

//   Future<void> saveToken(String token) async {
//     await _storage.write(key: AppConfig.accessTokenKey, value: token);
//   }

//   Future<String?> getToken() async {
//     return await _storage.read(key: AppConfig.accessTokenKey);
//   }

//   Future<void> deleteToken() async {
//     await _storage.delete(key: AppConfig.accessTokenKey);
//   }
// }
