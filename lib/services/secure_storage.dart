import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyUsername = 'username';
  static const _keyLoggedIn = 'loggedin';

  static Future setUsername(String username) async =>
  await _storage.write(key: _keyUsername, value: username);

  static Future getUsername() async =>
  await _storage.read(key: _keyUsername);

  static Future setLoggedIn(String loggedin) async =>
      await _storage.write(key: _keyLoggedIn, value: loggedin);

  static Future getLoggedIn() async =>
      await _storage.read(key: _keyLoggedIn);

}