import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String _username = '';
  String? _profileImagePath;

  String get username => _username;
  String? get profileImagePath => _profileImagePath;

  void updateProfile(String username, String? imagePath) {
    _username = username;
    _profileImagePath = imagePath;
    notifyListeners();
  }

  void setProfile(String username, String? imagePath) {
    _username = username;
    _profileImagePath = imagePath;
    notifyListeners();
  }
}
