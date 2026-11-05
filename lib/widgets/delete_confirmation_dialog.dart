import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/vehicle.dart';
import 'app_dialog_header.dart';
import 'registration_plate_badge.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.vehicle,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const AppDialogHeader(
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.red,
                iconBgColor: AppColors.deleteBg,
                title: 'Delete Vehicle Record',
                subtitle: 'This action cannot be reversed',
              ),

              // Vehicle Highlight Box
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.softGray,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    RegistrationPlateBadge(plateNumber: vehicle.vehicleNumber),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        '${vehicle.brand} ${vehicle.model} (${vehicle.year})',
                        style: AppTypography.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Are you sure you want to permanently remove this vehicle from the management system?',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red, // Red #D32F2F (Delete / Error only)
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.delete_forever, size: 18),
                    label: const Text('Delete Vehicle'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
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
}
