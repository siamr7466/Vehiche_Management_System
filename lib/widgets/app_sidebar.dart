import 'package:flutter/material.dart';
import '../constants/app_routes.dart';
import '../services/auth_service.dart';

enum NavPage { dashboard, vehicles }

/// Modern, sleek Left Sidebar Navigation for VehiclePro
/// Styled with a dark slate palette (#0F172A / #1E293B) matching modern automotive SaaS portals.
class AppSidebar extends StatelessWidget {
  final NavPage selectedPage;
  final ValueChanged<NavPage> onPageSelected;
  final VoidCallback onRegisterVehiclePressed;
  final bool isDrawer;
  final int? vehicleCount;

  const AppSidebar({
    super.key,
    required this.selectedPage,
    required this.onPageSelected,
    required this.onRegisterVehiclePressed,
    this.isDrawer = false,
    this.vehicleCount,
  });

  static const Color sidebarBg = Color(0xFF0F172A);      // Slate 900
  static const Color sidebarCardBg = Color(0xFF1E293B);  // Slate 800
  static const Color accentBlue = Color(0xFF2563EB);     // Blue 600
  static const Color activeNavBg = Color(0xFF1E293B);    // Slate 800 active
  static const Color textMuted = Color(0xFF94A3B8);      // Slate 400
  static const Color borderDark = Color(0xFF334155);     // Slate 700

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: sidebarBg,
        border: isDrawer
            ? null
            : const Border(right: BorderSide(color: Color(0xFF1E293B), width: 1)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Sleek Brand Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.directions_car_filled_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'VehiclePro',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'PRO',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF60A5FA),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Fleet Operations System',
                          style: TextStyle(
                            fontSize: 11,
                            color: textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Color(0xFF1E293B), height: 1),
            ),
            const SizedBox(height: 16),

            // 2. Primary Action Button: "+ Register Vehicle"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: accentBlue.withValues(alpha: 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add_rounded, size: 19),
                label: const Text(
                  'Register Vehicle',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
                onPressed: () {
                  if (isDrawer) Navigator.of(context).pop();
                  onRegisterVehiclePressed();
                },
              ),
            ),
            const SizedBox(height: 20),

            // 3. Section Label: NAVIGATION
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                'MAIN NAVIGATION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
            const SizedBox(height: 6),

            // 4. Navigation Links
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.grid_view_outlined,
                    activeIcon: Icons.grid_view_rounded,
                    label: 'Dashboard',
                    isSelected: selectedPage == NavPage.dashboard,
                    onTap: () {
                      onPageSelected(NavPage.dashboard);
                      if (isDrawer) Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 4),
                  _buildNavItem(
                    context: context,
                    icon: Icons.directions_car_outlined,
                    activeIcon: Icons.directions_car_filled_rounded,
                    label: 'Vehicles',
                    badgeText: vehicleCount != null ? '$vehicleCount' : null,
                    isSelected: selectedPage == NavPage.vehicles,
                    onTap: () {
                      onPageSelected(NavPage.vehicles);
                      if (isDrawer) Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Modern User Profile Card & Sign Out
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: sidebarCardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderDark),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1.5),
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AuthService.isLoggedIn ? (AuthService.currentUser ?? 'Admin') : 'Not Signed In',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            AuthService.isLoggedIn ? 'Administrator' : 'Sign In Required',
                            style: const TextStyle(
                              fontSize: 11,
                              color: textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        AuthService.isLoggedIn ? Icons.logout_rounded : Icons.login_rounded,
                        size: 19,
                        color: AuthService.isLoggedIn ? const Color(0xFFEF4444) : const Color(0xFF60A5FA),
                      ),
                      tooltip: AuthService.isLoggedIn ? 'Sign Out' : 'Sign In',
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        if (AuthService.isLoggedIn) {
                          AuthService().logout();
                        }
                        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    String? badgeText,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        hoverColor: const Color(0xFF1E293B).withValues(alpha: 0.5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: const Color(0xFF334155))
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 20,
                color: isSelected ? const Color(0xFF60A5FA) : textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                  ),
                ),
              ),
              if (badgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ] else if (isSelected) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF60A5FA),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
