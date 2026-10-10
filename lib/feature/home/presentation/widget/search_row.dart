import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/widget/product_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class SearchRow extends StatelessWidget {
  const SearchRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              final cubit = context.read<HomeCuibtCubit>();
              final cartCubit = context.read<CartCubit>();
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(
                  products: cubit.state.products,
                  cartCubit: cartCubit,
                  homeCubit: cubit,
                ),
              );
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              height: 40.h,
              padding: EdgeInsets.only(right: 15.w, left: 6.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6F8),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 0.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.search_normal_1,
                    size: 20.sp,
                    color: ColorManger.primaryLight,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      context.translate(AppStrings.findYourProducts),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        _MicButton(),
      ],
    );
  }
}

class _MicButton extends StatefulWidget {
  @override
  State<_MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<_MicButton>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _tooltip;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _removeTooltip();
    _controller.dispose();
    super.dispose();
  }

  void _removeTooltip() {
    _tooltip?.remove();
    _tooltip = null;
  }

  void _showComingSoon(BuildContext context) {
    HapticFeedback.lightImpact();
    _removeTooltip();

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    _tooltip = OverlayEntry(
      builder: (_) => _ComingSoonBubble(
        anchorOffset: offset,
        anchorSize: size,
        fadeAnim: _fadeAnim,
        scaleAnim: _scaleAnim,
        onDismiss: () {
          _controller.reverse().then((_) => _removeTooltip());
        },
      ),
    );

    Overlay.of(context).insert(_tooltip!);
    _controller.forward(from: 0);

    // Auto-dismiss after 2.5s
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (_tooltip != null && mounted) {
        _controller.reverse().then((_) => _removeTooltip());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showComingSoon(context),
      child: Container(
        height: 42.h,
        width: 42.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorManger.primaryLight.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.02),
            width: 1,
          ),
        ),
        child: Icon(Icons.mic_none, size: 18.sp, color: ColorManger.primary),
      ),
    );
  }
}

class _ComingSoonBubble extends StatelessWidget {
  final Offset anchorOffset;
  final Size anchorSize;
  final Animation<double> fadeAnim;
  final Animation<double> scaleAnim;
  final VoidCallback onDismiss;

  const _ComingSoonBubble({
    required this.anchorOffset,
    required this.anchorSize,
    required this.fadeAnim,
    required this.scaleAnim,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    // Position the bubble below the mic button
    const double bubbleWidth = 190.0;
    const double gap = 2.0;
    const double tailSize = 8.0;

    final double left =
        (anchorOffset.dx + anchorSize.width / 2 - bubbleWidth / 2).clamp(
          12.0,
          MediaQuery.of(context).size.width - bubbleWidth - 12.0,
        );
    // top = bottom edge of the button + gap + tail
    final double top = anchorOffset.dy + anchorSize.height + gap;

    // Tail horizontal center relative to left edge of bubble
    final double tailX = (anchorOffset.dx + anchorSize.width / 2 - left).clamp(
      16.0,
      bubbleWidth - 16.0,
    );

    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          // Full-screen dismiss area
          Positioned.fill(child: Container(color: Colors.transparent)),

          Positioned(
            top: top,
            left: left,
            width: bubbleWidth,
            child: FadeTransition(
              opacity: fadeAnim,
              child: ScaleTransition(
                scale: scaleAnim,
                alignment: Alignment.topCenter,
                child: _BubbleCard(
                  tailX: tailX,
                  bubbleWidth: bubbleWidth,
                  tailSize: tailSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleCard extends StatelessWidget {
  final double tailX;
  final double bubbleWidth;
  final double tailSize;

  const _BubbleCard({
    required this.tailX,
    required this.bubbleWidth,
    required this.tailSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tail pointing UP (above bubble body)
        Padding(
          padding: EdgeInsets.only(left: tailX - tailSize),
          child: CustomPaint(
            size: Size(tailSize * 2, tailSize),
            painter: _TailPainter(pointDown: false),
          ),
        ),

        // Bubble body
        Material(
          color: Colors.transparent,
          child: Container(
            width: bubbleWidth,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: ColorManger.primaryLight.withValues(alpha: 0.10),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'قيد التطوير 🚧',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: ColorManger.authTitleDark,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'المساعد الصوتى قريباً!',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: ColorManger.authSubtitleGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TailPainter extends CustomPainter {
  final bool pointDown;
  const _TailPainter({this.pointDown = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final Path path;
    if (pointDown) {
      // Triangle pointing down (bubble above button)
      path = Path()
        ..moveTo(0, 0)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(size.width, 0)
        ..close();
    } else {
      // Triangle pointing up (bubble below button)
      path = Path()
        ..moveTo(0, size.height)
        ..lineTo(size.width / 2, 0)
        ..lineTo(size.width, size.height)
        ..close();
    }

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
