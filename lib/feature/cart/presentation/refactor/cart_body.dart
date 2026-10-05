import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_state.dart';
import 'package:aleman/feature/cart/presentation/screen/empty_cart.dart';
import 'package:aleman/core/statsScreen/global_error.dart';
import 'package:aleman/feature/cart/presentation/screen/cart_loading.dart';
import 'package:aleman/feature/cart/presentation/widget/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class CartBody extends StatefulWidget {
  const CartBody({super.key});

  @override
  State<CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  @override
  void initState() {
    super.initState();
    // Fetch cart data when screen opens
    context.read<CartCubit>().getCart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.status == CartStatus.loading && !state.isDeleting) {
          return const CartLoadingScreen();
        }

        if (state.status == CartStatus.error) {
          return GlobalError(
            onRetry: () {
              context.read<CartCubit>().getCart();
            },
          );
        }

        final cart = state.cart;
        if (cart == null || cart.items.isEmpty) {
          return EmptyCart();
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: cart.items.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      HapticFeedback.mediumImpact();
                      context.read<CartCubit>().deleteCartItem(item.id);
                    },
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      padding: EdgeInsetsDirectional.only(end: 22.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.trash, color: Colors.white, size: 22.sp),
                          SizedBox(height: 4.h),
                          Text(
                            'حذف',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11.5.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: CartItemCard(key: ValueKey(item.id), item: item),
                  );
                },
              ),
            ),
            _CartSummaryBottomBar(
              totalPrice: cart.totalPrice,
              totalWeight: cart.totalWeightTons > 0
                  ? '${cart.totalWeightTons.toStringAsFixed(1)} طن'
                  : '${cart.totalWeightKg.toStringAsFixed(1)} كجم',
            ),
          ],
        );
      },
    );
  }
}

class _CartSummaryBottomBar extends StatelessWidget {
  final double totalPrice;
  final String totalWeight;

  const _CartSummaryBottomBar({
    required this.totalPrice,
    required this.totalWeight,
  });

  String _formatPrice(double price) {
    final parts = price.toStringAsFixed(2).split('.');
    final wholePart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$wholePart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Total Price Section
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'المجموع',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (totalWeight.isNotEmpty) ...[
                        Text(
                          ' ($totalWeight)',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${_formatPrice(totalPrice)} ج.م.',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  CustomPaint(
                    size: Size(double.infinity, 2.h),
                    painter: const _DottedLinePainter(color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),

            SizedBox(width: 20.w),

            // Checkout Button
            Expanded(
              child: SizedBox(
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.checkoutRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManger.primaryLight,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'إتمام الشراء',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;

  const _DottedLinePainter({this.color = const Color(0xFF94A3B8)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round;

    const dotRadius = 0.8;
    const dotSpacing = 3.0;
    double currentX = 0;

    while (currentX < size.width) {
      canvas.drawCircle(Offset(currentX, size.height / 2), dotRadius, paint);
      currentX += dotSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
