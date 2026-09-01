import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aleman/core/style/images/asset_manger.dart';

void showFallingEggs(BuildContext context) {
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final Offset position = renderBox.localToGlobal(Offset.zero);
  final Size size = renderBox.size;
  
  // Center of the button
  final double startX = position.dx + (size.width / 2);
  // Bottom of the button
  final double startY = position.dy + size.height;

  final overlayState = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => FallingEggsOverlay(
      startX: startX,
      startY: startY,
    ),
  );

  overlayState.insert(overlayEntry);

  // Remove the overlay after the animation finishes
  Future.delayed(const Duration(milliseconds: 2500), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}

class FallingEggsOverlay extends StatefulWidget {
  final double startX;
  final double startY;

  const FallingEggsOverlay({
    super.key,
    required this.startX,
    required this.startY,
  });

  @override
  State<FallingEggsOverlay> createState() => _FallingEggsOverlayState();
}

class _FallingEggsOverlayState extends State<FallingEggsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  late List<EggModel> _eggs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    // Generate eggs falling sequentially
    _eggs = List.generate(8, (index) {
      return EggModel(
        startX: widget.startX, // Fixed X position (center of button)
        startY: widget.startY,
        delay: index * 0.1, // Sequential delay (0.0, 0.1, 0.2...)
        speed: 0.8 + _random.nextDouble() * 0.2, // Consistent fall speed
        size: 20.0, // Consistent size
        rotation: _random.nextDouble() * 2 * pi, // Random initial rotation
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: _eggs.map((egg) {
              // Calculate Y position based on animation progress
              double progress =
                  (_controller.value - egg.delay) / (1.0 - egg.delay);
              if (progress < 0) progress = 0;

              // Start at button's bottom, fall down
              double yPos = egg.startY + (progress * (size.height) * egg.speed);
              // Center the egg horizontally around the button's center
              double xPos = egg.startX - (egg.size / 2) + (_random.nextDouble() * 10 - 5); // Add slight horizontal flutter

              return Positioned(
                left: xPos,
                top: yPos,
                child: Transform.rotate(
                  angle: egg.rotation + progress * pi * 3, // Spin as it falls
                  child: Image.asset(
                    ImageAsset.eggIcon,
                    width: egg.size,
                    height: egg.size,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class EggModel {
  final double startX;
  final double startY;
  final double delay;
  final double speed;
  final double size;
  final double rotation;

  EggModel({
    required this.startX,
    required this.startY,
    required this.delay,
    required this.speed,
    required this.size,
    required this.rotation,
  });
}
