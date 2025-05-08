import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:kasut/providers/wishlist_provider.dart';

class AuthService {
  // Map to store loaded users from JSON
  static Map<String, Map<String, dynamic>> _users = {};
  static bool _usersLoaded = false;

  // Current user data
  static Map<String, dynamic>? _currentUser;
  static Map<String, dynamic>? get currentUser => _currentUser;

  // Load users from JSON file
  static Future<void> _loadUsers() async {
    if (_usersLoaded) return;

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/user.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> usersList = jsonData['users'];

      for (var user in usersList) {
        _users[user['email']] = user;
      }

      _usersLoaded = true;
      debugPrint('AuthService: Loaded ${_users.length} users from JSON');
    } catch (e) {
      debugPrint('AuthService: Error loading users from JSON: $e');
      // Initialize with empty map if loading fails
      _users = {};
      _usersLoaded = true;
    }
  }

  /// Attempts to sign up a new user.
  /// Returns true if signup is successful, false otherwise (e.g., email already exists).
  static Future<bool> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    // Ensure users are loaded
    await _loadUsers();

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
      // Create new user with default values
      _users[email] = {
        'email': email,
        'username': username,
        'password': password,
        'kasutCredit': 0,
        'sellCredit': 0,
        'kasutPoints': 0,
        'registeredAsSeller': false,
      };

      debugPrint('AuthService: Signup successful for $email.');
      // In a real app, you would save this back to the JSON file or database
      return true;
    }
  }

  /// Attempts to log in a user.
  /// Returns the user data if login is successful, null otherwise.
  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    // Ensure users are loaded
    await _loadUsers();

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      debugPrint('AuthService: Login failed - Fields cannot be empty.');
      return null;
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    debugPrint('AuthService: Attempting login for $email.');

    final user = _users[email];
    if (user != null && user['password'] == password) {
      debugPrint('AuthService: Login successful for $email.');

      // Create a copy of user data without the password for security
      _currentUser = Map<String, dynamic>.from(user);
      _currentUser!.remove('password');

      return _currentUser;
    } else {
      debugPrint('AuthService: Login failed - Invalid email or password.');
      _currentUser = null;
      return null;
    }
  }

  // Logout method
  static void logout() {
    _currentUser = null;
    // Clear wishlist when user logs out
    // You'll need to access this from a BuildContext with the provider
    debugPrint('AuthService: User logged out.');
  }

  /// Gets user credit information
  static Map<String, dynamic> getUserCredits() {
    if (_currentUser == null) {
      return {'kasutCredit': 0, 'sellCredit': 0, 'kasutPoints': 0};
    }

    return {
      'kasutCredit': _currentUser!['kasutCredit'] ?? 0,
      'sellCredit': _currentUser!['sellCredit'] ?? 0,
      'kasutPoints': _currentUser!['kasutPoints'] ?? 0,
    };
  }

  /// Checks if current user is registered as seller
  static bool isRegisteredAsSeller() {
    return _currentUser != null &&
        (_currentUser!['registeredAsSeller'] ?? false);
  }

  // Static method to clear wishlist from any context
  static void clearWishlistFromProvider(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
      listen: false,
    );
    wishlistProvider.clearWishlist();
  }
}
