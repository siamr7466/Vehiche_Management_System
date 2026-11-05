class AuthService {
  static bool isLoggedIn = false;
  static String? currentUser;

  /// Authenticate user credentials.
  /// Currently validates demo credentials ('admin' / 'admin').
  /// Later, this will call the Spring Boot REST API (/api/auth/login).
  Future<bool> login(String username, String password) async {
    // Simulating quick network delay for realistic UX
    await Future.delayed(const Duration(milliseconds: 500));

    if (username.trim().toLowerCase() == 'admin' && password == 'admin') {
      isLoggedIn = true;
      currentUser = 'Admin';
      return true;
    }
    return false;
  }

  /// Log out the current user session
  void logout() {
    isLoggedIn = false;
    currentUser = null;
  }
}

