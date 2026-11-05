import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/vehicle.dart';
import 'app_dialog_header.dart';
import 'delete_action_button.dart';
import 'registration_plate_badge.dart';
import 'status_badge.dart';

class VehicleDetailsDialog extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VehicleDetailsDialog({
    super.key,
    required this.vehicle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Unified Header
              AppDialogHeader(
                icon: Icons.directions_car_filled_rounded,
                title: 'Vehicle Overview',
                subtitle: 'System Record ID: #${vehicle.id ?? 'New'}',
                trailing: StatusBadge(status: vehicle.status),
              ),

              // License Plate Highlight
              Center(
                child: RegistrationPlateBadge(
                  plateNumber: vehicle.vehicleNumber,
                  isLarge: true,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Details Container
              Container(
                decoration: BoxDecoration(
                  color: AppColors.softGray,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.category_outlined, 'Vehicle Type', vehicle.vehicleType),
                    const Divider(height: 1),
                    _buildDetailRow(Icons.directions_car_outlined, 'Make & Model', '${vehicle.brand} ${vehicle.model}'),
                    const Divider(height: 1),
                    _buildDetailRow(Icons.calendar_today_outlined, 'Manufacturing Year', '${vehicle.year}'),
                    const Divider(height: 1),
                    _buildDetailRow(Icons.person_outline, 'Registered Owner', vehicle.ownerName),
                    const Divider(height: 1),
                    _buildDetailRow(Icons.phone_outlined, 'Owner Phone', vehicle.ownerContact),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Bottom Actions: Matches Component Examples
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Matches "Delete Action" Component Example
                  DeleteActionButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDelete();
                    },
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Vehicle'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onEdit();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm + 2),
          Text(label, style: AppTypography.caption.copyWith(fontSize: 13)),
          const Spacer(),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
