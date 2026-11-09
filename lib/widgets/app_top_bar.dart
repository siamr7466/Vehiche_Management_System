import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../services/auth_service.dart';

/// Top Bar for the Main Workspace
/// Includes Breadcrumbs, Quick Refresh, Notification Bell, and Admin Profile
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPageName;
  final VoidCallback? onMenuPressed;
  final bool showMenuButton;
  final VoidCallback? onRefresh;

  const AppTopBar({
    super.key,
    required this.currentPageName,
    this.onMenuPressed,
    this.showMenuButton = false,
    this.onRefresh,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.topBarHeight);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;
    final isVeryCompact = screenWidth < 460;

    return Container(
      height: AppSpacing.topBarHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? AppSpacing.md : AppSpacing.xxl,
      ),
      child: Row(
        children: [
          // Mobile Hamburger Button
          if (showMenuButton) ...[
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary, size: 20),
              onPressed: onMenuPressed,
              tooltip: 'Open Navigation Menu',
            ),
            const SizedBox(width: AppSpacing.xs),
          ],

          // Breadcrumbs Navigation Hierarchy (responsive on small screens)
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isVeryCompact) ...[
                  Text(
                    'VehiclePro',
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Text(
                      '/',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ),
                ],
                Flexible(
                  child: Text(
                    currentPageName,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Quick Refresh Action
          if (onRefresh != null) ...[
            IconButton(
              icon: const Icon(Icons.refresh, size: 19, color: AppColors.textSecondary),
              tooltip: 'Refresh Data',
              onPressed: onRefresh,
            ),
            const SizedBox(width: AppSpacing.xs),
          ],

          // Notification Bell
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 21, color: AppColors.textSecondary),
            tooltip: 'No new notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('No new notifications.'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: AppSpacing.xs),

          // User Profile Pill (adapts to icon-only on mobile)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isVeryCompact ? AppSpacing.xs + 2 : AppSpacing.sm + 2,
              vertical: AppSpacing.xs + 1,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                if (!isVeryCompact) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    AuthService.currentUser ?? 'Admin',
                    style: AppTypography.bodyMedium.copyWith(fontSize: 12.5),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
