import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lightweight vector pattern overlay of agricultural line-art (wheat, leaf, gear, corn, drop)
/// matching Phase 2 of the splash intro described by the user.
class SplashPatternOverlay extends StatelessWidget {
  final double opacity;

  const SplashPatternOverlay({super.key, required this.opacity});

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0.0) return const SizedBox.shrink();

    return IgnorePointer(
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: CustomPaint(
          size: Size.infinite,
          painter: _SplashPatternPainter(),
        ),
      ),
    );
  }
}

class _SplashPatternPainter extends CustomPainter {
  final Paint _strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.3
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = const Color(0xFF1B422E).withValues(alpha: 0.09);

  @override
  void paint(Canvas canvas, Size size) {
    final items = <_PatternSpec>[
      // Top section
      _PatternSpec(0.12, 0.08, 26, -0.3, _PatternType.wheat),
      _PatternSpec(0.50, 0.06, 22, 0.2, _PatternType.gear),
      _PatternSpec(0.86, 0.09, 28, 0.4, _PatternType.leaf),
      _PatternSpec(0.28, 0.16, 20, 0.1, _PatternType.corn),
      _PatternSpec(0.74, 0.18, 24, -0.2, _PatternType.drop),

      // Upper-mid section
      _PatternSpec(0.08, 0.28, 24, 0.5, _PatternType.leaf),
      _PatternSpec(0.92, 0.30, 26, -0.4, _PatternType.wheat),
      _PatternSpec(0.20, 0.38, 20, -0.2, _PatternType.gear),
      _PatternSpec(0.80, 0.40, 22, 0.3, _PatternType.corn),

      // Lower-mid section
      _PatternSpec(0.10, 0.62, 26, 0.2, _PatternType.gear),
      _PatternSpec(0.90, 0.64, 24, -0.5, _PatternType.wheat),
      _PatternSpec(0.24, 0.72, 22, -0.3, _PatternType.drop),
      _PatternSpec(0.82, 0.74, 26, 0.4, _PatternType.leaf),

      // Bottom section
      _PatternSpec(0.14, 0.84, 24, 0.3, _PatternType.wheat),
      _PatternSpec(0.50, 0.88, 22, -0.2, _PatternType.gear),
      _PatternSpec(0.88, 0.86, 26, -0.3, _PatternType.corn),
      _PatternSpec(0.30, 0.94, 20, 0.1, _PatternType.leaf),
      _PatternSpec(0.72, 0.95, 22, 0.4, _PatternType.drop),
    ];

    for (final item in items) {
      final center = Offset(item.relX * size.width, item.relY * size.height);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(item.rotation);

      switch (item.type) {
        case _PatternType.wheat:
          _drawWheat(canvas, item.size);
          break;
        case _PatternType.leaf:
          _drawLeaf(canvas, item.size);
          break;
        case _PatternType.gear:
          _drawGear(canvas, item.size);
          break;
        case _PatternType.corn:
          _drawCorn(canvas, item.size);
          break;
        case _PatternType.drop:
          _drawDrop(canvas, item.size);
          break;
      }

      canvas.restore();
    }
  }

  void _drawLeaf(Canvas canvas, double s) {
    final path = Path();
    path.moveTo(0, -s * 0.5);
    path.quadraticBezierTo(s * 0.45, -s * 0.2, 0, s * 0.5);
    path.quadraticBezierTo(-s * 0.45, -s * 0.2, 0, -s * 0.5);
    canvas.drawPath(path, _strokePaint);
    canvas.drawLine(Offset(0, -s * 0.4), Offset(0, s * 0.4), _strokePaint);
  }

  void _drawWheat(Canvas canvas, double s) {
    canvas.drawLine(Offset(0, -s * 0.5), Offset(0, s * 0.5), _strokePaint);
    for (int i = 0; i < 4; i++) {
      final y = -s * 0.35 + (i * s * 0.22);
      final grainW = s * 0.25;
      final grainH = s * 0.16;
      final rightGrain = Path()
        ..moveTo(0, y)
        ..quadraticBezierTo(grainW, y - grainH * 0.5, grainW * 0.8, y + grainH)
        ..quadraticBezierTo(0, y + grainH * 0.8, 0, y);
      canvas.drawPath(rightGrain, _strokePaint);

      final leftGrain = Path()
        ..moveTo(0, y)
        ..quadraticBezierTo(
          -grainW,
          y - grainH * 0.5,
          -grainW * 0.8,
          y + grainH,
        )
        ..quadraticBezierTo(0, y + grainH * 0.8, 0, y);
      canvas.drawPath(leftGrain, _strokePaint);
    }
  }

  void _drawGear(Canvas canvas, double s) {
    final r = s * 0.4;
    canvas.drawCircle(Offset.zero, r * 0.45, _strokePaint);
    const teeth = 6;
    final path = Path();
    for (int i = 0; i < teeth; i++) {
      final angle = (i * 2 * math.pi) / teeth;
      const step = (2 * math.pi) / (teeth * 3);
      final rInner = r * 0.72;
      final rOuter = r;

      final p1 = Offset(
        math.cos(angle - step) * rInner,
        math.sin(angle - step) * rInner,
      );
      final p2 = Offset(
        math.cos(angle - step * 0.5) * rOuter,
        math.sin(angle - step * 0.5) * rOuter,
      );
      final p3 = Offset(
        math.cos(angle + step * 0.5) * rOuter,
        math.sin(angle + step * 0.5) * rOuter,
      );
      final p4 = Offset(
        math.cos(angle + step) * rInner,
        math.sin(angle + step) * rInner,
      );

      if (i == 0) {
        path.moveTo(p1.dx, p1.dy);
      } else {
        path.lineTo(p1.dx, p1.dy);
      }
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(p3.dx, p3.dy);
      path.lineTo(p4.dx, p4.dy);
    }
    path.close();
    canvas.drawPath(path, _strokePaint);
  }

  void _drawCorn(Canvas canvas, double s) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: s * 0.45, height: s * 0.8),
      Radius.circular(s * 0.22),
    );
    canvas.drawRRect(rect, _strokePaint);
    canvas.drawLine(Offset(0, -s * 0.35), Offset(0, s * 0.35), _strokePaint);
    canvas.drawLine(Offset(-s * 0.15, 0), Offset(s * 0.15, 0), _strokePaint);
  }

  void _drawDrop(Canvas canvas, double s) {
    final path = Path();
    path.moveTo(0, -s * 0.45);
    path.cubicTo(s * 0.35, -s * 0.05, s * 0.35, s * 0.4, 0, s * 0.45);
    path.cubicTo(-s * 0.35, s * 0.4, -s * 0.35, -s * 0.05, 0, -s * 0.45);
    path.close();
    canvas.drawPath(path, _strokePaint);
  }

  @override
  bool shouldRepaint(covariant _SplashPatternPainter oldDelegate) => false;
}

enum _PatternType { wheat, leaf, gear, corn, drop }

class _PatternSpec {
  final double relX;
  final double relY;
  final double size;
  final double rotation;
  final _PatternType type;

  const _PatternSpec(this.relX, this.relY, this.size, this.rotation, this.type);
}
