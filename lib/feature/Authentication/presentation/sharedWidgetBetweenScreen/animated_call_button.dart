import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedCallButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedCallButton({super.key, required this.onPressed});

  @override
  State<AnimatedCallButton> createState() => _AnimatedCallButtonState();
}

class _AnimatedCallButtonState extends State<AnimatedCallButton>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _rippleController,
        builder: (context, child) {
          return CustomPaint(
            painter: _RipplePainter(_rippleController.value),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Center(
                child: AnimatedBuilder(
                  animation: _shakeController,
                  builder: (context, child) {
                    // Using sin wave to create a shake effect
                    final angle = (math.sin(_shakeController.value * math.pi * 10) * 0.15);
                    return Transform.rotate(
                      angle: angle,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE8F5E9), // Very light green / whiteish
                        ),
                        child: const Icon(
                          Icons.phone,
                          color: Color(0xFF4CAF50), // Green color
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;

  _RipplePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double baseRadius = 22.5; // Half of inner container width

    // Define colors for ripples based on the provided image
    final Paint paint1 = Paint()
      ..color = const Color(0xFF81C784).withValues(alpha: (1.0 - progress) * 0.6)
      ..style = PaintingStyle.fill;

    final Paint paint2 = Paint()
      ..color = const Color(0xFFA5D6A7).withValues(alpha: (1.0 - progress) * 0.4)
      ..style = PaintingStyle.fill;

    // Outer ripple
    canvas.drawCircle(center, baseRadius + (progress * 25), paint2);

    // Inner ripple
    double progress2 = progress - 0.3;
    if (progress2 < 0) progress2 += 1.0;
    
    canvas.drawCircle(center, baseRadius + (progress2 * 15), paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
