import 'package:flutter/foundation.dart';
import 'secure_storage.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _loggedIn = 'false';

  String get username => _username;
  String get loggedIn => _loggedIn;

  Future<void> initialize() async {
    _username = await UserSecureStorage.getUsername() ?? '';
    final loggedInValue = await UserSecureStorage.getLoggedIn();
    _loggedIn = loggedInValue;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    UserSecureStorage.setUsername(username);
    notifyListeners();
  }

  void setLoggedIn(String loggedIn) {
    _loggedIn = loggedIn;
    UserSecureStorage.setLoggedIn(loggedIn.toString());
    notifyListeners();
  }
}
