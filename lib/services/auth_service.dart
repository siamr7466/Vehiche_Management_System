import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

/// Authentication service connecting to Spring Boot's REST authentication endpoints.
/// Manages session tokens and current user credentials securely.
class AuthService {
  static bool isLoggedIn = false;
  static String? currentUser;
  static String? authToken;
  static String? lastErrorMessage;

  /// Authenticate administrator credentials against Spring Boot (/api/auth/login).
  Future<bool> login(String username, String password) async {
    lastErrorMessage = null;

    try {
      final response = await http
          .post(
            Uri.parse(AppConstants.authLoginEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'username': username.trim(),
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        authToken = data['token']?.toString();
        currentUser = data['username']?.toString() ?? 'Admin';
        isLoggedIn = true;
        return true;
      } else {
        isLoggedIn = false;
        authToken = null;
        currentUser = null;
        lastErrorMessage = _parseError(response.body) ??
            'Invalid username or password. Please verify your credentials.';
        return false;
      }
    } catch (e) {
      isLoggedIn = false;
      authToken = null;
      currentUser = null;
      lastErrorMessage =
          'Cannot connect to Spring Boot backend at ${AppConstants.apiBaseUrl}. Ensure the server is running.';
      return false;
    }
  }

  /// Log out and invalidate session on both client and backend.
  Future<void> logout() async {
    if (authToken != null) {
      try {
        await http.post(
          Uri.parse(AppConstants.authLogoutEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ).timeout(const Duration(seconds: 5));
      } catch (_) {
        // Fall through to clear local session state regardless
      }
    }

    isLoggedIn = false;
    currentUser = null;
    authToken = null;
    lastErrorMessage = null;
  }

  String? _parseError(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded['message'] ?? decoded['error'];
      }
    } catch (_) {}
    return null;
  }
}
