class AppConstants {
  // Production API base URL is injected at build time via:
  //   flutter build web --dart-define=API_BASE_URL=https://your-render-url.onrender.com
  //
  // For local development, falls back to localhost:8080 automatically.
  // Never put production credentials or secrets in this file.
  // Production API base URL (falls back to live Render backend)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://vms-backend-jjch.onrender.com',
  );

  static const String vehiclesEndpoint = '$apiBaseUrl/api/vehicles';
  static const String authLoginEndpoint = '$apiBaseUrl/api/auth/login';
  static const String authLogoutEndpoint = '$apiBaseUrl/api/auth/logout';

  // Backward compatibility alias
  static const String baseUrl = vehiclesEndpoint;

  // Supported vehicle types
  static const List<String> vehicleTypes = [
    'Car',
    'SUV',
    'Truck',
    'Motorcycle',
    'Van',
    'Bus',
  ];

  // Vehicle statuses
  static const List<String> vehicleStatuses = [
    'Active',
    'Under Maintenance',
    'Inactive',
  ];
}
