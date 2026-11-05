import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// Reusable Modal Dialog Header
/// Enforces identical header structure, spacing, and typography across all dialogs.
class AppDialogHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const AppDialogHeader({
    super.key,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.iconBgColor = AppColors.primaryLight,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.dialogTitle),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.caption),
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: AppSpacing.sm),
            ],
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
              tooltip: 'Close',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const Divider(height: AppSpacing.xxl),
      ],
    );
  }
}

