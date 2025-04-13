import 'package:flutter/foundation.dart';

class AuthService {
  // Static map to store users: {'email': {'username': 'user', 'password': 'pwd'}}
  static final Map<String, Map<String, String>> _users = {};

  // Method to get the current user data - simple placeholder for now
  // In a real app, this would involve proper state management
  static Map<String, String>? _currentUser;
  static Map<String, String>? get currentUser => _currentUser;

  /// Attempts to sign up a new user.
  /// Returns true if signup is successful, false otherwise (e.g., email already exists).
  Future<bool> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    // Basic validation
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      debugPrint('AuthService: Signup failed - Fields cannot be empty.');
      return false;
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (_users.containsKey(email)) {
      debugPrint('AuthService: Signup failed - Email already exists.');
      return false; // Email already exists
    } else {
      _users[email] = {'username': username, 'password': password};
      debugPrint('AuthService: Signup successful for $email.');
      debugPrint('Current users: $_users'); // Log current users for debugging
      return true;
    }
  }

  /// Attempts to log in a user.
  /// Returns the user data map {'username': username, 'email': email} if login is successful, null otherwise.
  Future<Map<String, String>?> login({
    required String email,
    required String password,
  }) async {
    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      debugPrint('AuthService: Login failed - Fields cannot be empty.');
      return null;
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    debugPrint('AuthService: Attempting login for $email.');
    debugPrint(
      'Checking against users: $_users',
    ); // Log current users for debugging

    final user = _users[email];
    if (user != null && user['password'] == password) {
      debugPrint('AuthService: Login successful for $email.');
      _currentUser = {'username': user['username']!, 'email': email};
      return _currentUser; // Login successful
    } else {
      debugPrint('AuthService: Login failed - Invalid email or password.');
      _currentUser = null;
      return null; // Invalid email or password
    }
  }

  /// Logs out the current user.
  void logout() {
    _currentUser = null;
    debugPrint('AuthService: User logged out.');
  }
}
