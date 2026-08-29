import 'dart:math' as math;

import 'package:flutter/material.dart';

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
    const double outerSize = 85.0;
    const double innerSize = 58.0;

    return Semantics(
      button: true,
      label: isLastPage ? 'ابدأ التسوق' : 'التالي',
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: outerSize,
          height: outerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Segmented Animated Circular Progress Ring with gaps between steps
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: progress),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOutCubic,
                builder: (context, value, child) {
                  return CustomPaint(
                    size: const Size(outerSize, outerSize),
                    painter: _ProgressRingPainter(
                      progress: value,
                      totalSteps: totalSteps,
                      trackColor: Colors.white.withValues(alpha: 0.18),
                      progressColor: const Color(0xFFFFFFFF),
                      strokeWidth: 4,
                      gapDistance: 10.0,
                    ),
                  );
                },
              ),

              // Center Circular Action Button
              Container(
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 60, 100, 34),
                      Color(0xFF65CA28),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        169,
                        215,
                        142,
                      ).withValues(alpha: 0.35),
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
                    child: isLastPage
                        ? Image.asset(
                            "assets/icons/bag.png",
                            key: const ValueKey('cart_image'),
                            color: Colors.white,
                            width: 24,
                            height: 24,
                          )
                        : const Icon(
                            Icons.arrow_forward,
                            key: ValueKey('arrow_icon'),
                            color: Color(0xFFFFFFFF),
                            size: 28,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final int totalSteps;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;
  final double gapDistance;

  _ProgressRingPainter({
    required this.progress,
    required this.totalSteps,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
    this.gapDistance = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (totalSteps <= 1) {
      // Single continuous ring if only 1 step
      canvas.drawCircle(center, radius, trackPaint);
      if (progress > 0) {
        canvas.drawArc(
          rect,
          -math.pi / 2,
          2 * math.pi * progress.clamp(0.0, 1.0),
          false,
          progressPaint,
        );
      }
      return;
    }

    // Segmented ring with empty gaps between each step
    final double stepSweep = (2 * math.pi) / totalSteps;
    final double gapAngle = gapDistance / radius;
    final double segmentSweep = stepSweep - gapAngle;

    for (int i = 0; i < totalSteps; i++) {
      // Start of this segment (centered between gaps)
      final double segmentStart =
          -math.pi / 2 + (i * stepSweep) + (gapAngle / 2);

      // 1. Draw background track segment
      canvas.drawArc(rect, segmentStart, segmentSweep, false, trackPaint);

      // 2. Draw active progress segment
      final double stepStart = i / totalSteps;
      final double stepEnd = (i + 1) / totalSteps;

      if (progress > stepStart) {
        final double segmentFraction =
            ((progress - stepStart) / (stepEnd - stepStart)).clamp(0.0, 1.0);
        final double activeSweep = segmentSweep * segmentFraction;

        if (activeSweep > 0.001) {
          canvas.drawArc(rect, segmentStart, activeSweep, false, progressPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.totalSteps != totalSteps ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gapDistance != gapDistance;
  }
}
