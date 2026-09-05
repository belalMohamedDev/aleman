import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/style/color/color_manger.dart';

class CircularProgressButton extends StatelessWidget {
  final double progress; // 0.0 to 1.0 (e.g. 0.25, 0.5, 0.75, 1.0)
  final VoidCallback onTap;
  final bool isLastPage;
  final int totalSteps;

  const CircularProgressButton({
    super.key,
    required this.progress,
    required this.onTap,
    this.isLastPage = false,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    const double outerSize = 110.0;
    const double trackRadius = 42.0;
    const double innerSize = 62.0;

    return Semantics(
      button: true,
      label: isLastPage ? 'ابدأ التسوق' : 'التالي',
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: outerSize,
          height: outerSize,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: progress),
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOutCubic,
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Wheat Spike Orbit Animated Circular Progress Ring
                  CustomPaint(
                    size: const Size(outerSize, outerSize),
                    painter: _OrbitProgressPainter(
                      progress: value,
                      trackRadius: trackRadius,
                      trackColor: ColorManger.gold.withValues(alpha: 0.2),
                      progressColor: ColorManger.gold,
                      dotColor: ColorManger.agriculturalGreen,
                      strokeWidth: 3.0,
                    ),
                  ),

                  // Center Circular Action Button
                  Container(
                    width: innerSize,
                    height: innerSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [ColorManger.gold, ColorManger.goldDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManger.gold.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Transform.rotate(
                          angle: isLastPage
                              ? 0
                              : ((3 * math.pi / 4) +
                                        (1.5 * math.pi) *
                                            value.clamp(0.0, 1.0)) -
                                    math.pi,
                          child: Icon(
                            isLastPage
                                ? Iconsax.bag_happy4
                                : Iconsax.arrow_left_2,
                            key: ValueKey('arrow_icon_$isLastPage'),
                            color: ColorManger.primaryLight,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OrbitProgressPainter extends CustomPainter {
  final double progress;
  final double trackRadius;
  final Color trackColor;
  final Color progressColor;
  final Color dotColor;
  final double strokeWidth;

  _OrbitProgressPainter({
    required this.progress,
    required this.trackRadius,
    required this.trackColor,
    required this.progressColor,
    required this.dotColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // The arc starts from bottom-left (135 degrees) and sweeps to bottom-right
    double startAngle = 3 * math.pi / 4;
    double totalSweep = 1.5 * math.pi;

    // 1. Draw full background track (dimmed)
    _drawTrack(canvas, center, trackRadius, trackPaint);

    if (progress > 0) {
      // 2. Draw active track, clipped by a wedge based on current progress
      canvas.save();
      Path clipPath = Path();
      clipPath.moveTo(center.dx, center.dy);
      clipPath.arcTo(
        Rect.fromCircle(center: center, radius: trackRadius * 2),
        startAngle,
        totalSweep * progress.clamp(0.0, 1.0),
        false,
      );
      clipPath.lineTo(center.dx, center.dy);
      clipPath.close();
      canvas.clipPath(clipPath);

      _drawTrack(canvas, center, trackRadius, activePaint);
      canvas.restore();

      // 3. Draw the glowing dot at the tip of the current progress
      double currentAngle = startAngle + totalSweep * progress.clamp(0.0, 1.0);
      final Offset tipOffset = Offset(
        center.dx + trackRadius * math.cos(currentAngle),
        center.dy + trackRadius * math.sin(currentAngle),
      );

      final glowPaint = Paint()
        ..color = dotColor.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(tipOffset, strokeWidth * 2.5, glowPaint);

      final dotPaint = Paint()
        ..color = dotColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(tipOffset, strokeWidth * 1.5, dotPaint);
    }
  }

  // Helper to draw the wheat spike and arc path
  void _drawTrack(Canvas canvas, Offset center, double radius, Paint paint) {
    double startAngle = 3 * math.pi / 4;
    double totalSweep = 1.5 * math.pi;

    // Main orbit arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweep,
      false,
      paint,
    );

    // Wheat Spike (Leaves)
    int numLeaves = 7;
    // Spread leaves along the left side (from ~140 deg to ~220 deg)
    double leafStartAngle = 3.15 * math.pi / 4;
    double leafEndAngle = 4.85 * math.pi / 4;

    for (int i = 0; i <= numLeaves; i++) {
      double t = i / numLeaves;
      double a = leafStartAngle + t * (leafEndAngle - leafStartAngle);

      Offset p = center + Offset(radius * math.cos(a), radius * math.sin(a));

      // Tangent pointing forward
      double forward = a + math.pi / 2;
      double leafLen = 7.0; // length of the grain

      // Outward grain
      double angleOut = forward - math.pi / 3.0;
      Offset pOut =
          p +
          Offset(leafLen * math.cos(angleOut), leafLen * math.sin(angleOut));
      canvas.drawLine(p, pOut, paint);

      // Inward grain
      double angleIn = forward + math.pi / 3.0;
      Offset pIn =
          p + Offset(leafLen * math.cos(angleIn), leafLen * math.sin(angleIn));
      canvas.drawLine(p, pIn, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
