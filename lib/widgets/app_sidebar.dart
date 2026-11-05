import 'package:flutter/material.dart';
import '../constants/app_routes.dart';
import '../constants/app_theme.dart';
import '../services/auth_service.dart';
import 'app_logo.dart';

enum NavPage { dashboard, vehicles }

/// Item 1 in Business Application Layout:
/// Left Sidebar Navigation using the Deep Blue (#1F4E79) and Corporate Blue (#5B9BD5) palette.
class AppSidebar extends StatelessWidget {
  final NavPage selectedPage;
  final ValueChanged<NavPage> onPageSelected;
  final VoidCallback onRegisterVehiclePressed;
  final bool isDrawer;

  const AppSidebar({
    super.key,
    required this.selectedPage,
    required this.onPageSelected,
    required this.onRegisterVehiclePressed,
    this.isDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: isDrawer
            ? null
            : const Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sidebar Brand Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xl + 4,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: const AppLogo(iconSize: 24, isCompact: false),
          ),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),

          // Section Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xs),
            child: Text(
              'MAIN NAVIGATION',
              style: AppTypography.caption.copyWith(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: AppColors.deepBlue.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Navigation Links
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Column(
              children: [
                _buildNavItem(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isSelected: selectedPage == NavPage.dashboard,
                  onTap: () {
                    onPageSelected(NavPage.dashboard);
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: AppSpacing.xs),
                _buildNavItem(
                  icon: Icons.directions_car_outlined,
                  activeIcon: Icons.directions_car_filled_rounded,
                  label: 'Vehicles',
                  isSelected: selectedPage == NavPage.vehicles,
                  onTap: () {
                    onPageSelected(NavPage.vehicles);
                    if (isDrawer) Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: AppSpacing.xs),
                _buildNavItem(
                  icon: Icons.add_circle_outline_rounded,
                  activeIcon: Icons.add_circle_rounded,
                  label: 'Register Vehicle',
                  isSelected: false,
                  onTap: () {
                    if (isDrawer) Navigator.of(context).pop();
                    onRegisterVehiclePressed();
                  },
                ),
              ],
            ),
          ),

          const Spacer(),

          // Bottom Section: Administrator Profile & Logout
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.softGray,
                borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.corporateBlue.withValues(alpha: 0.3)),
                    ),
                    child: const Center(
                      child: Icon(Icons.person, size: 18, color: AppColors.deepBlue),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm + 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AuthService.currentUser ?? 'Admin',
                          style: AppTypography.bodyMedium.copyWith(fontSize: 12.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text(
                          'Administrator',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_outlined, size: 18, color: AppColors.red),
                    tooltip: 'Sign Out',
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      AuthService().logout();
                      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 20,
                color: isSelected ? AppColors.deepBlue : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.deepBlue : AppColors.charcoal,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.corporateBlue,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
