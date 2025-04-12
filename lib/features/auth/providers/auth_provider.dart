import 'package:flutter/foundation.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn = false; // Start as logged out

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    if (!_isLoggedIn) {
      _isLoggedIn = true;
      notifyListeners(); // Notify listeners about the state change
    }
  }

  void logout() {
    if (_isLoggedIn) {
      _isLoggedIn = false;
      notifyListeners(); // Notify listeners about the state change
    }
  }
}