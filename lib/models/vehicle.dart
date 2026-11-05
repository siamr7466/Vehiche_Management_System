class Vehicle {
  final int? id;
  final String vehicleNumber;
  final String vehicleType;
  final String brand;
  final String model;
  final int year;
  final String ownerName;
  final String ownerContact;
  final String status;

  Vehicle({
    this.id,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.year,
    required this.ownerName,
    required this.ownerContact,
    this.status = 'Active',
  });

  // Convert JSON from Spring Boot backend into Vehicle object
  // Uses safe parsing to prevent numeric TypeError in Flutter Web
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    int? parsedId;
    if (json['id'] != null) {
      if (json['id'] is int) {
        parsedId = json['id'] as int;
      } else {
        parsedId = int.tryParse(json['id'].toString());
      }
    }

    int parsedYear = DateTime.now().year;
    if (json['year'] != null) {
      if (json['year'] is int) {
        parsedYear = json['year'] as int;
      } else {
        parsedYear = int.tryParse(json['year'].toString()) ?? DateTime.now().year;
      }
    }

    return Vehicle(
      id: parsedId,
      vehicleNumber: json['vehicleNumber']?.toString() ?? '',
      vehicleType: json['vehicleType']?.toString() ?? 'Car',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      year: parsedYear,
      ownerName: json['ownerName']?.toString() ?? '',
      ownerContact: json['ownerContact']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Active',
    );
  }

  // Convert Vehicle object to JSON for HTTP POST / PUT requests
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'vehicleNumber': vehicleNumber.trim().toUpperCase(),
      'vehicleType': vehicleType,
      'brand': brand.trim(),
      'model': model.trim(),
      'year': year,
      'ownerName': ownerName.trim(),
      'ownerContact': ownerContact.trim(),
      'status': status,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  // Create a copy of Vehicle with updated fields
  Vehicle copyWith({
    int? id,
    String? vehicleNumber,
    String? vehicleType,
    String? brand,
    String? model,
    int? year,
    String? ownerName,
    String? ownerContact,
    String? status,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      ownerName: ownerName ?? this.ownerName,
      ownerContact: ownerContact ?? this.ownerContact,
      status: status ?? this.status,
    );
  }
}
