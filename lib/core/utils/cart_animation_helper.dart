import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartAnimationHelper {
  /// GlobalKey attached to the Cart icon/FAB to accurately target its position.
  static final GlobalKey cartKey = GlobalKey();

  /// Executes the flying image to cart animation using an OverlayEntry without any setState.
  static void runFlyToCartAnimation({
    required BuildContext context,
    required String imageUrl,
    Offset? startOffset,
    Size? startSize,
  }) {
    final overlayState = Overlay.of(context, rootOverlay: true);

    // Calculate start position
    final start = startOffset ??
        Offset(
          MediaQuery.of(context).size.width / 2 - 40,
          MediaQuery.of(context).size.height / 2 - 40,
        );
    final initialSize = startSize ?? const Size(80, 80);

    // Calculate end position (Cart FAB)
    Offset endOffset;
    Size endSize = const Size(48, 48);

    final targetRenderBox =
        cartKey.currentContext?.findRenderObject() as RenderBox?;
    if (targetRenderBox != null && targetRenderBox.hasSize) {
      endOffset = targetRenderBox.localToGlobal(Offset.zero);
      endSize = targetRenderBox.size;
    } else {
      // Fallback to bottom start (FloatingActionButtonLocation.miniStartFloat)
      final media = MediaQuery.of(context);
      endOffset = Offset(20, media.size.height - 90);
    }

    // Target center coordinates
    final targetCenter = Offset(
      endOffset.dx + endSize.width / 2,
      endOffset.dy + endSize.height / 2,
    );

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (ctx) => _FlyingImageWidget(
        imageUrl: imageUrl,
        startOffset: start,
        initialSize: initialSize,
        targetCenter: targetCenter,
        onComplete: () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
        },
      ),
    );

    overlayState.insert(overlayEntry);
  }
}

class _FlyingImageWidget extends StatefulWidget {
  final String imageUrl;
  final Offset startOffset;
  final Size initialSize;
  final Offset targetCenter;
  final VoidCallback onComplete;

  const _FlyingImageWidget({
    required this.imageUrl,
    required this.startOffset,
    required this.initialSize,
    required this.targetCenter,
    required this.onComplete,
  });

  @override
  State<_FlyingImageWidget> createState() => _FlyingImageWidgetState();
}

class _FlyingImageWidgetState extends State<_FlyingImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullUrl = widget.imageUrl.startsWith('http')
        ? widget.imageUrl
        : '${ApiConstants.baseUrl}${widget.imageUrl}';

    return AnimatedBuilder(
      animation: _curveAnimation,
      builder: (context, child) {
        final t = _curveAnimation.value;

        // Parabolic curved trajectory: lifts slightly before falling to cart
        final double currentX = widget.startOffset.dx +
            (widget.targetCenter.dx - widget.startOffset.dx) * t;

        final double linearY = widget.startOffset.dy +
            (widget.targetCenter.dy - widget.startOffset.dy) * t;

        // Quadratic arc peak in the middle
        final double arcPeak = -60.0 * (1 - (2 * t - 1) * (2 * t - 1));
        final double currentY = linearY + (t < 0.8 ? arcPeak : 0);

        // Scale down from original size to miniature
        final double currentWidth = widget.initialSize.width * (1.0 - 0.75 * t);
        final double currentHeight = widget.initialSize.height * (1.0 - 0.75 * t);

        // Subtle rotation & fade
        final double rotation = t * 0.4;
        final double opacity = (1.0 - 0.2 * t).clamp(0.0, 1.0);

        return Positioned(
          left: currentX - currentWidth / 2,
          top: currentY - currentHeight / 2,
          width: currentWidth,
          height: currentHeight,
          child: IgnorePointer(
            child: Opacity(
              opacity: opacity,
              child: Transform.rotate(
                angle: rotation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ColorManger.primary.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: ColorManger.primaryLight.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: fullUrl,
                      fit: BoxFit.contain,
                      errorWidget: (_, _, _) => Icon(
                        Icons.grass_rounded,
                        color: ColorManger.primaryLight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
