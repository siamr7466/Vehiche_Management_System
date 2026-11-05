class AppConstants {
  // Spring Boot backend REST API base URL
  static const String baseUrl = 'http://localhost:8080/api/vehicles';

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

