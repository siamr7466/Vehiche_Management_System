import 'package:flutter/material.dart';
import '../constants/app_routes.dart';
import '../services/auth_service.dart';

/// Top Bar for the Main Workspace
/// Includes Modern Breadcrumbs, Live Status Badge, Refresh Action, Notifications, and User Pill.
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
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 700;

    return Container(
      height: 64.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : 28,
      ),
      child: Row(
        children: [
          // Mobile Hamburger Menu Button
          if (showMenuButton) ...[
            IconButton(
              icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E293B), size: 22),
              onPressed: onMenuPressed,
              tooltip: 'Open Navigation',
            ),
            const SizedBox(width: 8),
          ],

          // Modern Breadcrumb Navigation
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (screenWidth >= 900) ...[
                  const Icon(
                    Icons.home_outlined,
                    size: 17,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'VehiclePro',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                  ),
                ],
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      currentPageName,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Quick Refresh Action
          if (onRefresh != null) ...[
            Tooltip(
              message: 'Refresh Fleet Data',
              child: InkWell(
                onTap: onRefresh,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 18,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],

          // Notification Bell
          Tooltip(
            message: 'Notifications',
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All fleet systems operational. No unread alerts.'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 18,
                      color: Color(0xFF475569),
                    ),
                    Positioned(
                      top: -1,
                      right: -1,
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // User Profile Pill (or Sign In button if unauthenticated)
          InkWell(
            onTap: () {
              if (!AuthService.isLoggedIn) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: AuthService.isLoggedIn
                          ? const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)])
                          : const LinearGradient(colors: [Color(0xFF94A3B8), Color(0xFF64748B)]),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        AuthService.isLoggedIn ? Icons.person : Icons.lock_outline_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AuthService.isLoggedIn ? (AuthService.currentUser ?? 'Admin') : 'Sign In',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AuthService.isLoggedIn ? const Color(0xFF0F172A) : const Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
