import 'package:flutter/material.dart';

/// Modernized Status Badge Component
/// Clean rounded pill with glowing dot indicator.
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  (Color text, Color bg, Color border, Color dot) _getColors() {
    switch (status.toLowerCase()) {
      case 'active':
        return (
          const Color(0xFF047857), // Emerald 700
          const Color(0xFFECFDF5), // Emerald 50
          const Color(0xFFA7F3D0), // Emerald 200
          const Color(0xFF10B981), // Emerald 500
        );
      case 'under maintenance':
        return (
          const Color(0xFFB45309), // Amber 700
          const Color(0xFFFFFBEB), // Amber 50
          const Color(0xFFFDE68A), // Amber 200
          const Color(0xFFF59E0B), // Amber 500
        );
      case 'inactive':
        return (
          const Color(0xFFB91C1C), // Red 700
          const Color(0xFFFEF2F2), // Red 50
          const Color(0xFFFECACA), // Red 200
          const Color(0xFFEF4444), // Red 500
        );
      default:
        return (
          const Color(0xFF475569),
          const Color(0xFFF8FAFC),
          const Color(0xFFE2E8F0),
          const Color(0xFF94A3B8),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (textColor, bgColor, borderColor, dotColor) = _getColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withValues(alpha: 0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
