import 'package:flutter/material.dart';

/// Clipper for the elegant upward curved top edge of the onboarding bottom sheet.
class CurvedCardClipper extends CustomClipper<Path> {
  final double curveHeight;

  const CurvedCardClipper({this.curveHeight = 28.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    // Start at left edge, curveHeight below top
    path.moveTo(0, curveHeight);
    // Smooth quadratic curve to apex at (size.width / 2, 0), then down to (size.width, curveHeight)
    path.quadraticBezierTo(
      size.width / 2,
      0,
      size.width,
      curveHeight,
    );
    // Down to bottom-right
    path.lineTo(size.width, size.height);
    // Across to bottom-left
    path.lineTo(0, size.height);
    // Close back to (0, curveHeight)
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CurvedCardClipper oldClipper) =>
      oldClipper.curveHeight != curveHeight;
}

/// Custom painter to draw a subtle soft shadow above the curved card.
class CurvedCardShadowPainter extends CustomPainter {
  final double curveHeight;

  const CurvedCardShadowPainter({this.curveHeight = 28.0});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, curveHeight);
    path.quadraticBezierTo(
      size.width / 2,
      0,
      size.width,
      curveHeight,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(
      path,
      Colors.black.withValues(alpha: 0.18),
      12.0,
      false,
    );
  }

  @override
  bool shouldRepaint(covariant CurvedCardShadowPainter oldDelegate) =>
      oldDelegate.curveHeight != curveHeight;
}
