import '../data/mock_vehicles.dart';
import '../models/vehicle.dart';

/// Vehicle Repository:
/// Currently operates exclusively on Temporary Mock Data.
/// All CRUD operations run in-memory without making any backend or API calls yet.
class VehicleRepository {
  // In-memory vehicle dataset initialized with mock records
  final List<Vehicle> _localVehicles = MockVehicleData.getInitialVehicles();
  int _nextLocalId = 7;

  /// Fetch all vehicles from the mock store
  Future<List<Vehicle>> getVehicles() async {
    // Small delay to simulate realistic responsive loading
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_localVehicles);
  }

  /// Check whether a vehicle registration number is already in use
  bool isDuplicate(String vehicleNumber, List<Vehicle> currentList, [int? currentId]) {
    final normalized = vehicleNumber.trim().toUpperCase();
    return currentList.any((v) {
      if (currentId != null && v.id == currentId) return false;
      return v.vehicleNumber.toUpperCase() == normalized;
    });
  }

  /// Add / Register a new vehicle in the mock store
  Future<Vehicle> addVehicle(Vehicle vehicle) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final newVehicle = vehicle.copyWith(id: _nextLocalId++);
    _localVehicles.add(newVehicle);
    return newVehicle;
  }

  /// Update an existing vehicle in the mock store
  Future<Vehicle> updateVehicle(Vehicle vehicle) async {
    if (vehicle.id == null) {
      throw Exception('Cannot update vehicle without an ID');
    }
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _localVehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _localVehicles[index] = vehicle;
    }
    return vehicle;
  }

  /// Delete a vehicle by ID from the mock store
  Future<void> deleteVehicle(int id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _localVehicles.removeWhere((v) => v.id == id);
  }
}
