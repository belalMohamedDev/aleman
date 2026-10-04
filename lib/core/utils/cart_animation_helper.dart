import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartAnimationHelper {
  static GlobalKey? cartKey;

  static GlobalKey? cartSearchKey;

  static final List<GlobalKey> _cartKeysStack = [];

  static void registerCartKey(GlobalKey key) {
    _cartKeysStack.remove(key);
    _cartKeysStack.add(key);
  }

  static void unregisterCartKey(GlobalKey key) {
    _cartKeysStack.remove(key);
  }

  static GlobalKey? get activeCartKey {
    for (int i = _cartKeysStack.length - 1; i >= 0; i--) {
      final key = _cartKeysStack[i];
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize && renderBox.attached) {
        return key;
      }
    }
    return null;
  }

  static final ValueNotifier<int> cartEggsCountNotifier = ValueNotifier<int>(0);
  static final ValueNotifier<double> cartBounceNotifier =
      ValueNotifier<double>(1.0);

  static void addEggToCart() {
    cartEggsCountNotifier.value = (cartEggsCountNotifier.value + 1).clamp(0, 8);
    triggerCartBounce();
  }

  static void triggerCartBounce() {
    cartBounceNotifier.value = 1.22;
    Future.delayed(const Duration(milliseconds: 120), () {
      cartBounceNotifier.value = 0.94;
      Future.delayed(const Duration(milliseconds: 100), () {
        cartBounceNotifier.value = 1.0;
      });
    });
  }

  static void resetCartEggs() {
    cartEggsCountNotifier.value = 0;
    cartBounceNotifier.value = 1.0;
  }

  static void runFlyToCartAnimation({
    required BuildContext context,
    required String imageUrl,
    Offset? startOffset,
    Size? startSize,
  }) {
    final overlayState = Overlay.of(context, rootOverlay: true);

    // Calculate start position
    final start =
        startOffset ??
        Offset(
          MediaQuery.of(context).size.width / 2 - 40,
          MediaQuery.of(context).size.height / 2 - 40,
        );
    final initialSize = startSize ?? const Size(80, 80);

    Offset endOffset;
    Size endSize = const Size(48, 48);

    RenderBox? targetRenderBox;

    final topKey = activeCartKey;
    if (topKey != null) {
      targetRenderBox = topKey.currentContext?.findRenderObject() as RenderBox?;
    }

    if (targetRenderBox == null || !targetRenderBox.hasSize || !targetRenderBox.attached) {
      targetRenderBox =
          cartSearchKey?.currentContext?.findRenderObject() as RenderBox?;
    }

    if (targetRenderBox == null || !targetRenderBox.hasSize || !targetRenderBox.attached) {
      targetRenderBox =
          cartKey?.currentContext?.findRenderObject() as RenderBox?;
    }

    if (targetRenderBox != null && targetRenderBox.hasSize) {
      endOffset = targetRenderBox.localToGlobal(Offset.zero);
      endSize = targetRenderBox.size;
    } else {
      // Fallback to top header cart button (on the left in RTL Arabic, right in LTR)
      final media = MediaQuery.of(context);
      final isRtl = Directionality.of(context) == TextDirection.rtl;
      final targetX = isRtl ? 24.0 : media.size.width - 66.0;
      final targetY = media.padding.top + 16.0;
      endOffset = Offset(targetX, targetY);
      endSize = const Size(42, 42);
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
          triggerCartBounce();
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
      duration: const Duration(milliseconds: 650),
    );

    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
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

        // Smooth parabolic arc factor (0 at t=0, 1 at t=0.5, 0 at t=1)
        final double arcFactor = 4 * t * (1 - t);

        // Linear interpolation components
        final double linearX = widget.startOffset.dx +
            (widget.targetCenter.dx - widget.startOffset.dx) * t;
        final double linearY = widget.startOffset.dy +
            (widget.targetCenter.dy - widget.startOffset.dy) * t;

        // Outward horizontal bow for organic flight path
        final double bowDirection =
            (widget.targetCenter.dx <= widget.startOffset.dx) ? -28.0 : 28.0;
        final double currentX = linearX + bowDirection * arcFactor;

        // Parabolic vertical lift (negative in Flutter coordinate system)
        final double arcLift = -48.0 * arcFactor;
        final double currentY = linearY + arcLift;

        // Scale down smoothly from initial size to cart-ready miniature (24px)
        const double targetDim = 24.0;
        final double currentWidth = widget.initialSize.width +
            (targetDim - widget.initialSize.width) * t;
        final double currentHeight = widget.initialSize.height +
            (targetDim - widget.initialSize.height) * t;

        // Subtle rotation & soft landing fade
        final double rotation = t * 0.35;
        final double opacity = t > 0.85
            ? (1.0 - ((t - 0.85) / 0.15)).clamp(0.0, 1.0)
            : 1.0;

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
