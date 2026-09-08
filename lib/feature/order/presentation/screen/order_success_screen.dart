// ignore_for_file: deprecated_member_use

import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderResponseModel order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isWesal = order.orderType == 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManger.primaryLight.withOpacity(0.12),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 68.sp,
                  color: ColorManger.primaryLight,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'تم استلام طلبك بنجاح!',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.primary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'رقم الطلب: ${order.orderNumber}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorManger.goldDark,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: ColorManger.backgroundItem,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.black.withOpacity(0.06)),
                ),
                child: Text(
                  isWesal
                      ? 'سيقوم فريق لوجستيات مصنع آل إيمان بتجهيز شحنتك والتواصل معك لتأكيد وصول سيارة الشحن إلى عنوانك.'
                      : 'تم تسجيل إذن التحميل الخاص بسيارتك في أرض المصنع. يمكنك التوجه للمصنع للاستلام في الموعد المحدد.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.homeRoute,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManger.primaryLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text(
                    'العودة للرئيسية',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
