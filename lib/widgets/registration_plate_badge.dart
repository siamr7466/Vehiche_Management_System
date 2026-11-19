import 'package:flutter/material.dart';

/// Modernized License / Registration Plate Badge
class RegistrationPlateBadge extends StatelessWidget {
  final String plateNumber;
  final bool isLarge;

  const RegistrationPlateBadge({
    super.key,
    required this.plateNumber,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLarge) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A), // Dark Slate
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF334155), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'REG',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              plateNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                letterSpacing: 1.5,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB), // European style blue badge
              borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
            ),
            child: const Text(
              'BD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 9.5,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Text(
              plateNumber,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 0.6,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
