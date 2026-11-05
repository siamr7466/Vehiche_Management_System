import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import '../models/vehicle.dart';
import 'app_dialog_header.dart';

class VehicleFormDialog extends StatefulWidget {
  final Vehicle? vehicle; // null if adding new, non-null if editing
  final List<Vehicle> existingVehicles; // For client-side duplicate check
  final void Function(Vehicle vehicle) onSave;

  const VehicleFormDialog({
    super.key,
    this.vehicle,
    required this.existingVehicles,
    required this.onSave,
  });

  @override
  State<VehicleFormDialog> createState() => _VehicleFormDialogState();
}

class _VehicleFormDialogState extends State<VehicleFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _vehicleNumberController;
  late TextEditingController _companyController;
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _ownerNameController;
  late TextEditingController _ownerContactController;

  late String _selectedVehicleType;
  late String _selectedStatus;

  bool get isEditing => widget.vehicle != null;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _vehicleNumberController = TextEditingController(text: v?.vehicleNumber ?? '');
    _companyController = TextEditingController(text: v?.company ?? '');
    _brandController = TextEditingController(text: v?.brand ?? '');
    _modelController = TextEditingController(text: v?.model ?? '');
    _yearController = TextEditingController(
      text: v != null ? v.year.toString() : DateTime.now().year.toString(),
    );
    _ownerNameController = TextEditingController(text: v?.ownerName ?? '');
    _ownerContactController = TextEditingController(text: v?.ownerContact ?? '');

    // Safely match vehicle type to available options to prevent runtime type / assertion errors
    final existingType = v?.vehicleType;
    if (existingType != null &&
        AppConstants.vehicleTypes.any((t) => t.toLowerCase() == existingType.toLowerCase())) {
      _selectedVehicleType = AppConstants.vehicleTypes
          .firstWhere((t) => t.toLowerCase() == existingType.toLowerCase());
    } else {
      _selectedVehicleType = AppConstants.vehicleTypes.first;
    }

    // Safely match status
    final existingStatus = v?.status;
    if (existingStatus != null &&
        AppConstants.vehicleStatuses.any((s) => s.toLowerCase() == existingStatus.toLowerCase())) {
      _selectedStatus = AppConstants.vehicleStatuses
          .firstWhere((s) => s.toLowerCase() == existingStatus.toLowerCase());
    } else {
      _selectedStatus = AppConstants.vehicleStatuses.first;
    }
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _companyController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _ownerNameController.dispose();
    _ownerContactController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final companyText = _companyController.text.trim();
    final ownerText = _ownerNameController.text.trim();

    final vehicle = Vehicle(
      id: widget.vehicle?.id,
      vehicleNumber: _vehicleNumberController.text.trim().toUpperCase(),
      company: companyText,
      vehicleType: _selectedVehicleType,
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      year: int.tryParse(_yearController.text.trim()) ?? DateTime.now().year,
      ownerName: ownerText.isNotEmpty ? ownerText : companyText,
      ownerContact: _ownerContactController.text.trim(),
      status: _selectedStatus,
    );

    widget.onSave(vehicle);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Unified Modal Header
                  AppDialogHeader(
                    icon: isEditing ? Icons.edit_road_rounded : Icons.add_circle_outline_rounded,
                    title: isEditing ? 'Edit Vehicle Record' : 'Register Vehicle',
                    subtitle: isEditing
                        ? 'Update specifications and ownership details'
                        : 'Enter vehicle details below to add to the fleet',
                  ),

                  // Form Field: Vehicle Number (Matches Component Example)
                  _buildFieldLabel('Vehicle Number *'),
                  TextFormField(
                    controller: _vehicleNumberController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: 'Enter vehicle number (e.g. DM-GHA-11-2233)',
                      prefixIcon: Icon(Icons.pin_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vehicle number is required';
                      }
                      final trimmedUpper = value.trim().toUpperCase();
                      final isDuplicate = widget.existingVehicles.any((v) {
                        if (isEditing && v.id == widget.vehicle?.id) return false;
                        return v.vehicleNumber.toUpperCase() == trimmedUpper;
                      });

                      if (isDuplicate) {
                        return 'A vehicle with this number already exists!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Form Field: Company (Matches Stark Group / Master Prompt)
                  _buildFieldLabel('Company *'),
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      hintText: 'Enter company or fleet name (e.g. Stark Industries)',
                      prefixIcon: Icon(Icons.business_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Company name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Vehicle Type & Status Dropdowns (Explicitly Typed DropdownMenuItem<String>)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Vehicle Type *'),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedVehicleType,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.category_outlined),
                              ),
                              items: AppConstants.vehicleTypes.map((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedVehicleType = val);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Status *'),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedStatus,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.flag_outlined),
                              ),
                              items: AppConstants.vehicleStatuses.map((String status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedStatus = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Brand & Model Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Make / Brand *'),
                            TextFormField(
                              controller: _brandController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Toyota, Honda',
                                prefixIcon: Icon(Icons.directions_car_outlined),
                              ),
                              validator: (val) =>
                                  val == null || val.trim().isEmpty ? 'Make is required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Model *'),
                            TextFormField(
                              controller: _modelController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Corolla, Civic',
                                prefixIcon: Icon(Icons.branding_watermark_outlined),
                              ),
                              validator: (val) =>
                                  val == null || val.trim().isEmpty ? 'Model is required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Manufacturing Year
                  _buildFieldLabel('Manufacturing Year *'),
                  TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'e.g. 2023',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Manufacturing year is required';
                      }
                      final year = int.tryParse(val.trim());
                      if (year == null || year < 1900 || year > DateTime.now().year + 1) {
                        return 'Enter a valid year';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Owner Name
                  _buildFieldLabel('Registered Owner *'),
                  TextFormField(
                    controller: _ownerNameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. John Doe',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Owner name is required' : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Owner Phone
                  _buildFieldLabel('Contact Phone *'),
                  TextFormField(
                    controller: _ownerContactController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'e.g. +1 555-0199',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Contact phone is required' : null,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check, size: 18),
                        label: Text(isEditing ? 'Save Changes' : 'Register Vehicle'),
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal, // Charcoal #1F2937
        ),
      ),
    );
  }
}
