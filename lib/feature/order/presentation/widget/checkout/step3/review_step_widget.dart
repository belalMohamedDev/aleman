// ignore_for_file: deprecated_member_use

import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/cubit/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ReviewStepWidget extends StatelessWidget {
  final CheckoutState state;
  final double cartSubtotal;
  final ValueChanged<String> onNotesChanged;

  const ReviewStepWidget({
    super.key,
    required this.state,
    required this.cartSubtotal,
    required this.onNotesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final finalTotal = (cartSubtotal - state.discount + state.shippingFee)
        .clamp(0.0, double.infinity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مراجعة وتأكيد تفاصيل الطلب',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: ColorManger.primary,
          ),
        ),
        SizedBox(height: 12.h),

        // Fulfillment Card (وصال أو أرض المصنع)
        _buildFulfillmentCard(),
        SizedBox(height: 12.h),

        // Payment Card
        _buildPaymentCard(),
        SizedBox(height: 14.h),

        // Notes input
        Text(
          'ملاحظات إضافية على الطلب',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: ColorManger.primary,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          initialValue: state.notes ?? '',
          onChanged: onNotesChanged,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'هل توجد أي ملاحظات خاصة بالتحميل أو التسليم أو التوقيت؟',
            hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: ColorManger.primaryLight,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 16.h),

        // Invoice Pricing Breakdown
        _buildPriceSummaryCard(finalTotal),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildFulfillmentCard() {
    final primary = ColorManger.primaryLight;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                state.isWesal ? Iconsax.car : Iconsax.building_35,
                color: primary,
                size: 22.sp,
              ),
              SizedBox(width: 15.w),
              Text(
                state.isWesal
                    ? 'طريقة الاستلام: وصال'
                    : 'طريقة الاستلام: أرض المصنع ',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          Divider(height: 20.h, color: Colors.grey.shade200),
          if (state.isWesal) ...[
            _buildInfoRow(
              'عنوان التوصيل',
              state.selectedAddress?.fullAddress ?? 'غير محدد',
            ),
            if (state.totalWeightTons > 0) ...[
              SizedBox(height: 6.h),
              _buildInfoRow(
                'إجمالي الكمية (الوزن)',
                '${state.totalWeightTons} طن',
              ),
            ],
            // _buildInfoRow('نوع الشاحنة', state.selectedTruckType?.title ?? 'دبابة'),
            SizedBox(height: 6.h),
            _buildInfoRow('تكلفة الشحن', '${state.shippingFee} ج.م'),
          ] else ...[
            _buildInfoRow('اسم السائق', state.driverName),
            SizedBox(height: 6.h),
            _buildInfoRow('رقم لوحة العربية', state.vehiclePlateNumber),
            SizedBox(height: 6.h),
            _buildInfoRow('رقم الرخصة', state.driverLicenseNumber),
            if (state.expectedPickupDate != null) ...[
              SizedBox(height: 6.h),
              _buildInfoRow(
                'موعد التحميل',
                '${state.expectedPickupDate!.year}/${state.expectedPickupDate!.month}/${state.expectedPickupDate!.day}',
              ),
            ],
            // SizedBox(height: 6.h),
            // _buildInfoRow('تكلفة الشحن', 'شحن مجاني (0 ج.م)'),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.card5, color: ColorManger.primaryLight, size: 22.sp),
              SizedBox(width: 8.w),
              Text(
                'طريقة الدفع',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.primaryLight,
                ),
              ),
            ],
          ),
          Divider(height: 20.h, color: Colors.grey.shade200),
          _buildInfoRow('طريقة السداد', state.paymentMethod.title),
          if (state.couponCode != null && state.couponCode!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            _buildInfoRow(
              'كوبون الخصم',
              '${state.couponCode} (-${state.discount} ج.م)',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceSummaryCard(double finalTotal) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorManger.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملخص الفاتورة',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: ColorManger.primary,
            ),
          ),
          SizedBox(height: 12.h),

          // إجمالي وزن الطلب
          if (state.totalWeightTons > 0) ...[
            _buildSummaryRow(
              'إجمالي وزن الطلبات',
              '${state.totalWeightTons} طن',
            ),
            SizedBox(height: 8.h),
          ],

          // سعر المنتجات
          _buildSummaryRow('إجمالي سعر المنتجات', '$cartSubtotal ج.م'),

          // قيمة الخصم إن وجدت
          if (state.discount > 0) ...[
            SizedBox(height: 8.h),
            _buildSummaryRow(
              'قيمة الخصم',
              '- ${state.discount} ج.م',
              isDiscount: true,
            ),
          ],

          // تكلفة الشحن (في حالة وصال)
          if (state.isWesal && state.shippingFee > 0) ...[
            SizedBox(height: 8.h),
            _buildSummaryRow(
              'تكلفة الشحن والتوصيل',
              '${state.shippingFee} ج.م',
            ),
          ],

          Divider(height: 24.h, color: Colors.grey.shade300),

          // الإجمالي النهائي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إجمالي سعر الطلب النهائي',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.primary,
                ),
              ),
              Text(
                '$finalTotal ج.م',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.goldDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String title,
    String value, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13.sp, color: Colors.black54),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDiscount ? Colors.redAccent : ColorManger.primaryLight,
          ),
        ),
      ],
    );
  }
}
