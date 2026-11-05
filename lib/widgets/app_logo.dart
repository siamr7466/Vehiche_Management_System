import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// Unified Product Brand Logo & Identity
/// Uses #1F4E79 (Deep Blue) and #5B9BD5 (Corporate Blue)
class AppLogo extends StatelessWidget {
  final double iconSize;
  final bool showText;
  final bool isCompact;

  const AppLogo({
    super.key,
    this.iconSize = 24,
    this.showText = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Brand Mark: "V" in Deep Blue to Corporate Blue Gradient
        Container(
          width: iconSize * 1.5,
          height: iconSize * 1.5,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.deepBlue, AppColors.corporateBlue],
            ),
            borderRadius: BorderRadius.circular(iconSize * 0.38),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepBlue.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'V',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: iconSize * 0.85,
                fontFamily: 'Segoe UI',
              ),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'VehiclePro',
                style: TextStyle(
                  fontSize: isCompact ? 17 : 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBlue, // Deep Blue #1F4E79
                  letterSpacing: -0.4,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              if (!isCompact)
                const Text(
                  'Vehicle Management System',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
