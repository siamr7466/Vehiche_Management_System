import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// Matches the "Delete Action" component example in the unified design specification:
/// Trash icon + "Delete" text in Red #D32F2F with soft light-red pill background.
class DeleteActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isCompact;
  final String tooltip;

  const DeleteActionButton({
    super.key,
    required this.onPressed,
    this.isCompact = false,
    this.tooltip = 'Delete Vehicle',
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusBadge),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? AppSpacing.sm : AppSpacing.md,
              vertical: isCompact ? AppSpacing.xs + 1 : AppSpacing.xs + 3,
            ),
            decoration: BoxDecoration(
              color: AppColors.deleteBg, // Soft Red tint
              borderRadius: BorderRadius.circular(AppSpacing.radiusBadge),
              border: Border.all(color: AppColors.deleteBorder, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete_outline_rounded,
                  size: 16,
                  color: AppColors.red, // Red #D32F2F
                ),
                if (!isCompact) ...[
                  const SizedBox(width: AppSpacing.xs + 1),
                  const Text(
                    'Delete',
                    style: TextStyle(
                      color: AppColors.red, // Red #D32F2F
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      fontFamily: AppTypography.fontFamily,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

