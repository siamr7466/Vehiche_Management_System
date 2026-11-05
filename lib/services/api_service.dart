import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/vehicle.dart';

class ApiService {
  final String _baseUrl = AppConstants.baseUrl;

  // Headers for JSON requests
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // 1. Fetch all vehicles (GET /api/vehicles)
  Future<List<Vehicle>> getAllVehicles() async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl), headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Vehicle.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load vehicles: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Could not connect to backend server: $e');
    }
  }

  // 2. Create / Register a new vehicle (POST /api/vehicles)
  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: _headers,
            body: jsonEncode(vehicle.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Vehicle.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 409 || response.statusCode == 400) {
        // Backend duplicate validation error
        final errorMsg = _extractErrorMessage(response.body);
        throw Exception(errorMsg ?? 'Vehicle number already exists!');
      } else {
        throw Exception('Failed to add vehicle: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // 3. Update an existing vehicle (PUT /api/vehicles/{id})
  Future<Vehicle> updateVehicle(int id, Vehicle vehicle) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl/$id'),
            headers: _headers,
            body: jsonEncode(vehicle.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Vehicle.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 409 || response.statusCode == 400) {
        final errorMsg = _extractErrorMessage(response.body);
        throw Exception(errorMsg ?? 'Vehicle number already exists!');
      } else {
        throw Exception('Failed to update vehicle: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // 4. Delete a vehicle (DELETE /api/vehicles/{id})
  Future<void> deleteVehicle(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseUrl/$id'), headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete vehicle: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to parse error messages returned from Spring Boot
  String? _extractErrorMessage(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded['message'] ?? decoded['error'];
      }
    } catch (_) {}
    return responseBody.isNotEmpty ? responseBody : null;
  }
}

