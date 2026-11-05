import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// Item 2 in Business Application Layout:
/// Page Header with Title on Left, Primary Action on Right.
/// Matches the "Primary Button" component example (#5B9BD5 Corporate Blue).
class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final Widget? customAction;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.customAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.md,
        children: [
          // Title (Deep Blue #1F4E79) & Subtitle on the Left
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTypography.pageHeading,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.caption.copyWith(fontSize: 13),
              ),
            ],
          ),

          // Primary Action on the Right (Corporate Blue #5B9BD5)
          if (customAction != null)
            customAction!
          else if (actionLabel != null && onAction != null)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.corporateBlue, // Corporate Blue #5B9BD5
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg + 2,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                ),
                elevation: 0,
              ),
              icon: Icon(actionIcon ?? Icons.add, size: 18),
              label: Text(
                actionLabel!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              onPressed: onAction,
            ),
        ],
      ),
    );
  }
}
