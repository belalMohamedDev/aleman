import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CouponInputWidget extends StatefulWidget {
  final String? appliedCoupon;
  final double discountAmount;
  final bool isApplying;
  final ValueChanged<String> onApplyCoupon;

  const CouponInputWidget({
    super.key,
    required this.appliedCoupon,
    required this.discountAmount,
    required this.isApplying,
    required this.onApplyCoupon,
  });

  @override
  State<CouponInputWidget> createState() => _CouponInputWidgetState();
}

class _CouponInputWidgetState extends State<CouponInputWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.appliedCoupon ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'كوبون الخصم',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: ColorManger.primary,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.confirmation_number_outlined,
                  color: ColorManger.goldDark, size: 22.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'أدخل كود الخصم (مثال: ALEMAN10)',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 38.h,
                child: ElevatedButton(
                  onPressed: widget.isApplying
                      ? null
                      : () => widget.onApplyCoupon(_controller.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManger.primaryLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: widget.isApplying
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('تطبيق'),
                ),
              ),
            ],
          ),
        ),
        if (widget.discountAmount > 0) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                'تم تطبيق الخصم بنجاح: ${widget.discountAmount} ج.م',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
