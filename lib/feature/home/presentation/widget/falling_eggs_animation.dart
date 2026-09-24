import 'dart:async';
import 'dart:math';

import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/core/utils/cart_animation_helper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Timer? _eggResetTimer;

Future<void> showFallingEggs(BuildContext context) async {
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final Offset position = renderBox.localToGlobal(Offset.zero);
  final Size size = renderBox.size;

  // Center of the chicken button
  final double startX = position.dx + (size.width / 2);
  final double startY = position.dy + size.height;

  // Locate the shopping cart target coordinates
  Offset targetCenter;
  RenderBox? targetBox =
      CartAnimationHelper.cartKey?.currentContext?.findRenderObject()
          as RenderBox?;

  if (targetBox != null && targetBox.hasSize) {
    final targetPos = targetBox.localToGlobal(Offset.zero);
    targetCenter = Offset(
      targetPos.dx + (targetBox.size.width / 2),
      targetPos.dy + (targetBox.size.height / 2) - 8,
    );
  } else {
    final media = MediaQuery.of(context).size;
    targetCenter = Offset(45, media.height - 85);
  }

  // Play the chicken sound
  final player = AudioPlayer();
  player.play(
    AssetSource('sounds/dragon-studio-chicken-sounds-487676.mp3'),
    position: const Duration(milliseconds: 500),
  );

  if (!context.mounted) return;

  final overlayState = Overlay.of(context, rootOverlay: true);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => FallingEggsOverlay(
      startOffset: Offset(startX, startY),
      targetOffset: targetCenter,
      onCompleted: () {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
          player.dispose();
        }
      },
    ),
  );

  overlayState.insert(overlayEntry);

  // Auto reset cart eggs 5 seconds after click
  _eggResetTimer?.cancel();
  _eggResetTimer = Timer(const Duration(milliseconds: 5000), () {
    CartAnimationHelper.resetCartEggs();
  });
}

class FallingEggsOverlay extends StatefulWidget {
  final Offset startOffset;
  final Offset targetOffset;
  final VoidCallback onCompleted;

  const FallingEggsOverlay({
    super.key,
    required this.startOffset,
    required this.targetOffset,
    required this.onCompleted,
  });

  @override
  State<FallingEggsOverlay> createState() => _FallingEggsOverlayState();
}

class _FallingEggsOverlayState extends State<FallingEggsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  late List<_FlyEggModel> _eggs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    // Generate 7 eggs flying in an expressive, staggered arc
    _eggs = List.generate(7, (index) {
      return _FlyEggModel(
        delay: index * 0.10, // Staggered flight launch
        durationFactor: 0.36, // Flight time fraction for each egg
        arcHeight: 55.0 + _random.nextDouble() * 45.0, // High parabolic curve
        lateralOffset: (_random.nextDouble() - 0.5) * 50.0, // Natural spread
        initialRotation: _random.nextDouble() * 2 * pi,
        spinSpeed: (1.5 + _random.nextDouble() * 2.0) * (_random.nextBool() ? 1 : -1),
      );
    });

    _controller.addListener(_checkLandedEggs);
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted();
      }
    });
  }

  void _checkLandedEggs() {
    final tTotal = _controller.value;
    for (final egg in _eggs) {
      if (!egg.hasLanded) {
        final rawProgress = (tTotal - egg.delay) / egg.durationFactor;
        if (rawProgress >= 1.0) {
          egg.hasLanded = true;
          CartAnimationHelper.addEggToCart();
          HapticFeedback.lightImpact();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_checkLandedEggs);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final tTotal = _controller.value;

          return Stack(
            clipBehavior: Clip.none,
            children: _eggs.map((egg) {
              final rawProgress = (tTotal - egg.delay) / egg.durationFactor;

              // Not yet launched
              if (rawProgress < 0.0) {
                return const SizedBox.shrink();
              }

              // Reached cart
              if (rawProgress >= 1.0) {
                return const SizedBox.shrink();
              }

              // In flight: smooth cubic curve
              final t = Curves.easeInOutCubic.transform(rawProgress);

              final start = widget.startOffset;
              final target = widget.targetOffset;

              // Quadratic Bezier control point:
              final midX = ((start.dx + target.dx) / 2) + egg.lateralOffset;
              final midY = min(start.dy, target.dy) - egg.arcHeight;

              // Quadratic Bezier interpolation
              final currentX =
                  (1 - t) * (1 - t) * start.dx +
                  2 * (1 - t) * t * midX +
                  t * t * target.dx;

              final currentY =
                  (1 - t) * (1 - t) * start.dy +
                  2 * (1 - t) * t * midY +
                  t * t * target.dy;

              // Scale egg down slightly as it approaches the basket (depth illusion)
              final eggSize = 25.0 - (t * 8.0);
              final rotation = egg.initialRotation + (t * egg.spinSpeed * pi * 2);

              return Positioned(
                left: currentX - (eggSize / 2),
                top: currentY - (eggSize / 2),
                child: Transform.rotate(
                  angle: rotation,
                  child: Image.asset(
                    ImageAsset.eggIcon,
                    width: eggSize,
                    height: eggSize,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
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

class _FlyEggModel {
  final double delay;
  final double durationFactor;
  final double arcHeight;
  final double lateralOffset;
  final double initialRotation;
  final double spinSpeed;
  bool hasLanded = false;

  _FlyEggModel({
    required this.delay,
    required this.durationFactor,
    required this.arcHeight,
    required this.lateralOffset,
    required this.initialRotation,
    required this.spinSpeed,
  });
}
