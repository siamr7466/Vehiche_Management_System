import 'package:flutter/material.dart';

/// Modernized Page Header
/// Title on the left, Primary Action on the right.
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
      padding: const EdgeInsets.only(bottom: 20),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 12,
        children: [
          // Title & Subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          // Primary Action
          if (customAction != null)
            customAction!
          else if (actionLabel != null && onAction != null)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB), // Blue 600
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: const Color(0xFF2563EB).withValues(alpha: 0.35),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(actionIcon ?? Icons.add_rounded, size: 19),
              label: Text(
                actionLabel!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                  letterSpacing: 0.2,
                ),
              ),
              onPressed: onAction,
            ),
        ],
      ),
    );
  }
}
