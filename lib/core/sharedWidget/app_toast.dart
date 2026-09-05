import 'dart:ui';
import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ToastType { success, error, info }

class AppToast {
  static OverlayEntry? _currentEntry;

  /// Show a success toast with agricultural / feed branding
  static void showSuccess(
    BuildContext? context, {
    required String message,
    String? title,
    Duration duration = const Duration(milliseconds: 3500),
  }) {
    _show(
      context,
      message: message,
      title: title ?? 'تم بنجاح 🌾',
      type: ToastType.success,
      duration: duration,
    );
  }

  /// Show an error toast
  static void showError(
    BuildContext? context, {
    required String message,
    String? title,
    Duration duration = const Duration(milliseconds: 3500),
  }) {
    _show(
      context,
      message: message,
      title: title ?? 'تنبيه ⚠️',
      type: ToastType.error,
      duration: duration,
    );
  }

  /// Show an info / notice toast
  static void showInfo(
    BuildContext? context, {
    required String message,
    String? title,
    Duration duration = const Duration(milliseconds: 3500),
  }) {
    _show(
      context,
      message: message,
      title: title ?? 'ملاحظة 🌾',
      type: ToastType.info,
      duration: duration,
    );
  }

  static void _show(
    BuildContext? context, {
    required String message,
    required String title,
    required ToastType type,
    required Duration duration,
  }) {
    // Resolve context from navigatorKey if null
    final targetContext = context ??
        instance<GlobalKey<NavigatorState>>().currentState?.overlay?.context ??
        instance<GlobalKey<NavigatorState>>().currentContext;

    if (targetContext == null) return;

    final overlayState = Overlay.maybeOf(targetContext);
    if (overlayState == null) return;

    // Haptic feedback
    if (type == ToastType.error) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    // Dismiss any active toast
    _currentEntry?.remove();
    _currentEntry = null;

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) => _ToastWidget(
        title: title,
        message: message,
        type: type,
        duration: duration,
        onDismiss: () {
          if (_currentEntry == entry) {
            _currentEntry?.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlayState.insert(entry);
  }
}

class _ToastWidget extends StatefulWidget {
  final String title;
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.title,
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const ElasticOutCurve(0.9),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );

    _controller.forward();

    // Auto-dismiss
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _accentColor {
    switch (widget.type) {
      case ToastType.success:
        return ColorManger.buttonColor;
      case ToastType.error:
        return const Color(0xFFFF4D4D);
      case ToastType.info:
        return ColorManger.gold;
    }
  }

  List<Color> get _glassGradient {
    switch (widget.type) {
      case ToastType.success:
        return [
          const Color(0xFF0F321B).withValues(alpha: 0.96),
          const Color(0xFF07190D).withValues(alpha: 0.98),
        ];
      case ToastType.error:
        return [
          const Color(0xFF330E12).withValues(alpha: 0.96),
          const Color(0xFF1B0709).withValues(alpha: 0.98),
        ];
      case ToastType.info:
        return [
          const Color(0xFF2D1F05).withValues(alpha: 0.96),
          const Color(0xFF160F02).withValues(alpha: 0.98),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 14,
      left: 14,
      right: 14,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Dismissible(
              key: const Key('app_toast_dismissible'),
              direction: DismissDirection.up,
              onDismissed: (_) => widget.onDismiss(),
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Main Glass Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _glassGradient,
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: _accentColor.withValues(alpha: 0.4),
                              width: 1.3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 22,
                                offset: const Offset(0, 10),
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: _accentColor.withValues(alpha: 0.2),
                                blurRadius: 25,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: _ShimmerSweepEffect(
                            child: Stack(
                              children: [
                                // Subtle farm watermark in background corner
                                Positioned(
                                  left: -12,
                                  bottom: -12,
                                  child: Opacity(
                                    opacity: 0.05,
                                    child: Image.asset(
                                      ImageAsset.feedBag,
                                      width: 80,
                                      height: 80,
                                      errorBuilder: (c, e, s) => const SizedBox(),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Content Row
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          _PeekingBadge(
                                            type: widget.type,
                                            accentColor: _accentColor,
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  widget.title,
                                                  style: TextStyle(
                                                    color: _accentColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Cairo',
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  widget.message,
                                                  style: TextStyle(
                                                    color: Colors.white.withValues(alpha: 0.9),
                                                    fontSize: 12.8,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Cairo',
                                                    height: 1.35,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          InkWell(
                                            onTap: _dismiss,
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              padding: const EdgeInsets.all(6.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white.withValues(alpha: 0.08),
                                              ),
                                              child: Icon(
                                                Icons.close_rounded,
                                                color: Colors.white.withValues(alpha: 0.6),
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Glowing animated countdown line
                                    _ShrinkingProgressBar(
                                      duration: widget.duration,
                                      color: _accentColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer light sweep beam across the card
class _ShimmerSweepEffect extends StatefulWidget {
  final Widget child;
  const _ShimmerSweepEffect({required this.child});

  @override
  State<_ShimmerSweepEffect> createState() => _ShimmerSweepEffectState();
}

class _ShimmerSweepEffectState extends State<_ShimmerSweepEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _sweepController.forward();
    });
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sweepController,
      builder: (context, child) {
        if (_sweepController.value == 0.0 || _sweepController.value == 1.0) {
          return widget.child;
        }

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final double value = _sweepController.value;
            final double left = (value * 3.0) - 1.0;
            return LinearGradient(
              begin: Alignment(left - 0.4, -1.0),
              end: Alignment(left + 0.4, 1.0),
              colors: [
                Colors.transparent,
                Colors.white.withValues(alpha: 0.22),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// The Animated Badge with tilt wiggle and 3D emblem
class _PeekingBadge extends StatefulWidget {
  final ToastType type;
  final Color accentColor;

  const _PeekingBadge({
    required this.type,
    required this.accentColor,
  });

  @override
  State<_PeekingBadge> createState() => _PeekingBadgeState();
}

class _PeekingBadgeState extends State<_PeekingBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wiggleController;
  late final Animation<double> _wiggleAnimation;

  @override
  void initState() {
    super.initState();
    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _wiggleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.09), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.09, end: 0.09), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.09, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _wiggleController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _wiggleController.forward();
    });
  }

  @override
  void dispose() {
    _wiggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _wiggleAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _wiggleAnimation.value,
          child: child,
        );
      },
      child: _buildBadgeContent(),
    );
  }

  Widget _buildBadgeContent() {
    switch (widget.type) {
      case ToastType.success:
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Outer glow halo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.45),
                    blurRadius: 14,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            // White emblem
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: widget.accentColor,
                  width: 2.2,
                ),
                gradient: const RadialGradient(
                  colors: [Colors.white, Color(0xFFF2FAF2)],
                ),
              ),
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                ImageAsset.alemanLogo,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.eco_rounded,
                  color: widget.accentColor,
                  size: 26,
                ),
              ),
            ),
            // Mini 3D check seal
            Positioned(
              bottom: -1,
              left: -1,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );

      case ToastType.error:
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4D4D).withValues(alpha: 0.45),
                    blurRadius: 14,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2C0F12),
                border: Border.all(
                  color: const Color(0xFFFF4D4D),
                  width: 2.2,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFFF5252),
                size: 26,
              ),
            ),
          ],
        );

      case ToastType.info:
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.45),
                    blurRadius: 14,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2B1D04),
                border: Border.all(
                  color: widget.accentColor,
                  width: 2.2,
                ),
              ),
              padding: const EdgeInsets.all(7),
              child: Image.asset(
                ImageAsset.farmer,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.notifications_active_rounded,
                  color: widget.accentColor,
                  size: 24,
                ),
              ),
            ),
          ],
        );
    }
  }
}

class _ShrinkingProgressBar extends StatefulWidget {
  final Duration duration;
  final Color color;

  const _ShrinkingProgressBar({required this.duration, required this.color});

  @override
  State<_ShrinkingProgressBar> createState() => _ShrinkingProgressBarState();
}

class _ShrinkingProgressBarState extends State<_ShrinkingProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            height: 2.8,
            width: MediaQuery.of(context).size.width * (1.0 - _controller.value),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.color.withValues(alpha: 0.3),
                  widget.color,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.6),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      },
    );
  }
}
