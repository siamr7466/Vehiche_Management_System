import 'package:flutter/material.dart';

/// Modernized Delete Action Button
class DeleteActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isCompact;
  final String tooltip;

  const DeleteActionButton({
    super.key,
    required this.onPressed,
    this.isCompact = false,
    this.tooltip = 'Delete Vehicle',
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 8 : 12,
              vertical: isCompact ? 6 : 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2), // Soft Red 50
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFECACA), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete_outline_rounded,
                  size: 16,
                  color: Color(0xFFDC2626), // Red 600
                ),
                if (!isCompact) ...[
                  const SizedBox(width: 5),
                  const Text(
                    'Delete',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
