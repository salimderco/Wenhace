import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Authentication service using singleton pattern
/// Manages user login, signup, and session persistence
/// Currently uses in-memory storage (demo mode)
/// In production, this would connect to a real backend API
class AuthService extends ChangeNotifier {
  // Singleton pattern: ensures only one instance exists
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance; // Returns the single instance
  AuthService._internal(); // Private constructor

  // Authentication state
  bool _isAuthenticated = false; // Whether user is logged in
  String? _currentUserEmail; // Currently logged in user's email
  String? _currentUserName; // Currently logged in user's name

  // Test credentials for demo purposes
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'password123';

  // In-memory user storage (simulating a database)
  // In production, this would be replaced with API calls
  final Map<String, Map<String, String>> _users = {
    testEmail: {
      'password': testPassword,
      'name': 'Test User',
    },
  };

  // Getters to access private state
  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserEmail => _currentUserEmail;
  String? get currentUserName => _currentUserName;

  /// Initialize authentication state from local storage
  /// Called at app startup to restore previous login session
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance(); // Get local storage
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false; // Load login state
    _currentUserEmail = prefs.getString('userEmail'); // Load saved email
    _currentUserName = prefs.getString('userName'); // Load saved name
    notifyListeners(); // Notify widgets that state changed
  }

  /// Login with email and password
  /// Validates credentials and saves session to local storage
  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    email = email.trim().toLowerCase(); // Normalize email

    // Validate input
    if (email.isEmpty || password.isEmpty) {
      return AuthResult(
        success: false,
        message: 'Please enter email and password',
      );
    }

    // Check if user exists
    if (!_users.containsKey(email)) {
      return AuthResult(
        success: false,
        message: 'No account found with this email',
      );
    }

    // Verify password
    if (_users[email]!['password'] != password) {
      return AuthResult(
        success: false,
        message: 'Incorrect password',
      );
    }

    // Login successful - update state
    _isAuthenticated = true;
    _currentUserEmail = email;
    _currentUserName = _users[email]!['name'];

    // Save session to local storage (persists across app restarts)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userEmail', email);
    await prefs.setString('userName', _currentUserName!);

    notifyListeners(); // Notify widgets of state change

    return AuthResult(
      success: true,
      message: 'Login successful',
    );
  }

  /// Sign up with email, password, and name
  /// Validates input, creates account, and auto-logs in
  Future<AuthResult> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    name = name.trim(); // Remove whitespace
    email = email.trim().toLowerCase(); // Normalize email

    // Validate all fields are filled
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return AuthResult(
        success: false,
        message: 'Please fill in all fields',
      );
    }

    // Validate email format
    if (!_isValidEmail(email)) {
      return AuthResult(
        success: false,
        message: 'Please enter a valid email address',
      );
    }

    // Validate password length
    if (password.length < 6) {
      return AuthResult(
        success: false,
        message: 'Password must be at least 6 characters',
      );
    }

    // Check if email already exists
    if (_users.containsKey(email)) {
      return AuthResult(
        success: false,
        message: 'An account with this email already exists',
      );
    }

    // Create new user account
    _users[email] = {
      'password': password,
      'name': name,
    };

    // Auto-login after successful signup
    _isAuthenticated = true;
    _currentUserEmail = email;
    _currentUserName = name;

    // Save session to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userEmail', email);
    await prefs.setString('userName', name);

    notifyListeners(); // Notify widgets of state change

    return AuthResult(
      success: true,
      message: 'Account created successfully',
    );
  }

  /// Logout current user
  /// Clears authentication state and local storage
  Future<void> logout() async {
    // Clear authentication state
    _isAuthenticated = false;
    _currentUserEmail = null;
    _currentUserName = null;

    // Clear all stored data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners(); // Notify widgets of state change
  }

  /// Validates email format using regex pattern
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

/// Result object returned by authentication operations
/// Contains success status and message for UI feedback
class AuthResult {
  final bool success; // Whether operation succeeded
  final String message; // Message to display to user

  AuthResult({required this.success, required this.message});
}

