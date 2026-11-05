import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// Unified License / Registration Plate Badge
class RegistrationPlateBadge extends StatelessWidget {
  final String plateNumber;
  final bool isLarge;

  const RegistrationPlateBadge({
    super.key,
    required this.plateNumber,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLarge) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md - 2,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A), // Dark Slate
          borderRadius: BorderRadius.circular(AppSpacing.radiusBadge + 2),
          border: Border.all(color: const Color(0xFF334155), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'REG',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              plateNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.5,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 1,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppSpacing.radiusBadge),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Text(
        plateNumber,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.5,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
