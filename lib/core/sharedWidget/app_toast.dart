import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

enum ToastType { success, error, info, warning }

class AppToast {
  static OverlayEntry? _currentEntry;

  /// Show a success toast
  static void showSuccess(
    BuildContext? context, {
    required String message,
    String? title,
    Duration duration = const Duration(milliseconds: 3500),
  }) {
    _show(
      context,
      message: message,
      title: title ?? 'تم بنجاح',
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
      title: title ?? 'تنبيه',
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
      title: title ?? 'ملاحظة',
      type: ToastType.info,
      duration: duration,
    );
  }

  /// Show a warning toast
  static void showWarning(
    BuildContext? context, {
    required String message,
    String? title,
    Duration duration = const Duration(milliseconds: 3500),
  }) {
    _show(
      context,
      message: message,
      title: title ?? 'تنبيه',
      type: ToastType.warning,
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
    final targetContext =
        context ??
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
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
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
    if (!mounted) return;
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
        return ColorManger.primaryLight;
      case ToastType.error:
        return const Color(0xFFDC2626);
      case ToastType.info:
      case ToastType.warning:
        return const Color(0xFFD97706);
    }
  }

  Color get _iconBgColor {
    switch (widget.type) {
      case ToastType.success:
        return ColorManger.primaryLight.withValues(alpha: 0.1);
      case ToastType.error:
        return const Color(0xFFFEE2E2);
      case ToastType.info:
      case ToastType.warning:
        return const Color(0xFFFEF3C7);
    }
  }

  IconData get _iconData {
    switch (widget.type) {
      case ToastType.success:
        return Iconsax.tick_circle;
      case ToastType.error:
        return Iconsax.close_circle;
      case ToastType.info:
      case ToastType.warning:
        return Iconsax.info_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Dismissible(
            key: const Key('app_toast_dismissible'),
            direction: DismissDirection.up,
            onDismissed: (_) => widget.onDismiss(),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _accentColor.withValues(alpha: 0.08),
                    width: 0.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: _accentColor.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon Badge
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: _iconBgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(
                              _iconData,
                              color: _accentColor,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  color: _accentColor,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Cairo',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.message,
                                style: const TextStyle(
                                  color: ColorManger.authSubtitleGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Cairo',
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Dismiss button
                        GestureDetector(
                          onTap: _dismiss,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.04),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: ColorManger.authHintGrey,
                              size: 15,
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
        ),
      ),
    );
  }
}
