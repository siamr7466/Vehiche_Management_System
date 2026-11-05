import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// Reusable Component: Status Badge
/// Matches the "Status Badge" component example in the unified design specification:
/// Green dot indicator + "Active" in Green #2E7D32 with soft green background container.
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  (Color text, Color bg, Color border) _getColors() {
    switch (status.toLowerCase()) {
      case 'active':
        return (AppColors.green, AppColors.activeBg, AppColors.activeBorder);
      case 'under maintenance':
        return (AppColors.maintenance, AppColors.maintenanceBg, AppColors.maintenanceBorder);
      case 'inactive':
        return (AppColors.red, AppColors.inactiveBg, AppColors.inactiveBorder);
      default:
        return (AppColors.textSecondary, AppColors.softGray, AppColors.border);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (textColor, bgColor, borderColor) = _getColors();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 4,
        vertical: AppSpacing.xs + 1,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
