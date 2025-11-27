import 'package:flutter/material.dart';

/// A widget that displays a single color card with lock state and hex code
class ColorCard extends StatelessWidget {
  final Color color;
  final bool isLocked;
  final VoidCallback onTap;
  final bool showHex;

  const ColorCard({
    Key? key,
    required this.color,
    required this.isLocked,
    required this.onTap,
    this.showHex = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        child: Stack(
          children: [
            // Display hex code at the bottom if showHex is true
            if (showHex)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getHexCode(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            // Display lock/unlock icon at the top right
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLocked ? Icons.lock : Icons.lock_open,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Converts the color to its hex code representation
  String _getHexCode() {
    return '#${color.red.toRadixString(16).padLeft(2, '0')}'
            '${color.green.toRadixString(16).padLeft(2, '0')}'
            '${color.blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }
}
