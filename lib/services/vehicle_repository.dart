import '../models/vehicle.dart';
import 'api_service.dart';

/// Vehicle Repository:
/// Connected directly to the Spring Boot REST API & PostgreSQL SQL Database.
/// Replaces temporary in-memory mock data with live backend persistence.
class VehicleRepository {
  final ApiService _apiService = ApiService();

  /// Fetch all vehicles from the Spring Boot REST API
  Future<List<Vehicle>> getVehicles() async {
    return await _apiService.getAllVehicles();
  }

  /// Add / Register a new vehicle in the SQL database via Spring Boot
  Future<Vehicle> addVehicle(Vehicle vehicle) async {
    return await _apiService.createVehicle(vehicle);
  }

  /// Update an existing vehicle in the SQL database via Spring Boot
  Future<Vehicle> updateVehicle(Vehicle vehicle) async {
    if (vehicle.id == null) {
      throw Exception('Cannot update vehicle without an ID');
    }
    return await _apiService.updateVehicle(vehicle.id!, vehicle);
  }

  /// Delete a vehicle by ID from the SQL database via Spring Boot
  Future<void> deleteVehicle(int id) async {
    await _apiService.deleteVehicle(id);
  }
}
