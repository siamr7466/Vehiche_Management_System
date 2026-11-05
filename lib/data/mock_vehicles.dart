import '../models/vehicle.dart';

/// Temporary Mock Data for testing and development
/// before the Java Spring Boot + MySQL backend is connected.
class MockVehicleData {
  static List<Vehicle> getInitialVehicles() {
    return [
      Vehicle(
        id: 1,
        vehicleNumber: 'DM-GHA-11-2233',
        company: 'Stark Industries',
        vehicleType: 'Car',
        brand: 'Toyota',
        model: 'Corolla Altis',
        year: 2023,
        ownerName: 'John Doe',
        ownerContact: '+1 555-0199',
        status: 'Active',
      ),
      Vehicle(
        id: 2,
        vehicleNumber: 'DH-MET-54-9812',
        company: 'Apex Logistics',
        vehicleType: 'SUV',
        brand: 'Honda',
        model: 'CR-V Turbo',
        year: 2022,
        ownerName: 'Sarah Jenkins',
        ownerContact: '+1 555-0245',
        status: 'Active',
      ),
      Vehicle(
        id: 3,
        vehicleNumber: 'CTG-TA-77-4321',
        company: 'Stark Freight Corp',
        vehicleType: 'Truck',
        brand: 'Ford',
        model: 'F-150 SuperDuty',
        year: 2021,
        ownerName: 'Robert Smith',
        ownerContact: '+1 555-0876',
        status: 'Under Maintenance',
      ),
      Vehicle(
        id: 4,
        vehicleNumber: 'SYL-LA-23-1109',
        company: 'Metro Express',
        vehicleType: 'Motorcycle',
        brand: 'Yamaha',
        model: 'MT-15 V2',
        year: 2024,
        ownerName: 'Alex Johnson',
        ownerContact: '+1 555-0312',
        status: 'Active',
      ),
      Vehicle(
        id: 5,
        vehicleNumber: 'RAJ-CHA-88-5544',
        company: 'Pacific Trans',
        vehicleType: 'Van',
        brand: 'Toyota',
        model: 'HiAce Commuter',
        year: 2020,
        ownerName: 'Emily Brown',
        ownerContact: '+1 555-0744',
        status: 'Inactive',
      ),
      Vehicle(
        id: 6,
        vehicleNumber: 'BAR-BA-99-3321',
        company: 'Stark Mobility Services',
        vehicleType: 'Bus',
        brand: 'Scania',
        model: 'Touring HD',
        year: 2023,
        ownerName: 'Michael Green',
        ownerContact: '+1 555-0633',
        status: 'Active',
      ),
    ];
  }
}

