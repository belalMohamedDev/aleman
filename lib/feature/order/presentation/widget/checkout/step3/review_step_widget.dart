import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/cubit/checkout_state.dart';
import 'package:aleman/feature/order/data/model/enums/order_enums.dart';
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
    final finalTotal = (cartSubtotal - state.discount + state.shippingFee)
        .clamp(0.0, double.infinity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fulfillment Info Card
        _buildSectionHeader('تفاصيل الاستلام والتوصيل'),
        SizedBox(height: 8.h),
        _buildFulfillmentCard(),
        SizedBox(height: 16.h),

        // Payment Info Card
        _buildSectionHeader('طريقة الدفع'),
        SizedBox(height: 8.h),
        _buildPaymentCard(),
        SizedBox(height: 16.h),

        // Order Notes
        _buildSectionHeader('ملاحظات إضافية (اختياري)'),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: state.notes ?? '',
            onChanged: onNotesChanged,
            maxLines: 3,
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF0F172A)),
            decoration: InputDecoration(
              hintText: 'هل توجد أي تعليمات خاصة بالتحميل أو التسليم؟',
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: ColorManger.primaryLight,
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.all(14.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Invoice Pricing Breakdown
        _buildSectionHeader('ملخص الفاتورة'),
        SizedBox(height: 8.h),
        _buildPriceSummaryCard(finalTotal),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.5.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildFulfillmentCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: ColorManger.primaryLight.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  state.isWesal ? Iconsax.truck_fast : Iconsax.buildings,
                  color: ColorManger.primaryLight,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                state.isWesal ? 'توصيل وصال للموقع' : 'استلام من أرض المصنع',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          Divider(height: 24.h, color: Colors.grey.shade100),
          if (state.isWesal) ...[
            _buildInfoRow(
              'عنوان التوصيل',
              state.selectedAddress?.fullAddress ?? 'غير محدد',
            ),
            if (state.totalWeightTons > 0) ...[
              SizedBox(height: 8.h),
              _buildInfoRow(
                'إجمالي وزن الشحنة',
                '${state.totalWeightTons.toStringAsFixed(1)} طن',
              ),
            ],
            SizedBox(height: 8.h),
            _buildInfoRow(
              'نوع سيارة الشحن',
              state.selectedTruckType != null
                  ? (state.requiredTrucksCount > 1
                        ? '${state.selectedTruckType!.title} (${state.requiredTrucksCount} سيارات)'
                        : state.selectedTruckType!.title)
                  : 'غير محدد',
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              state.requiredTrucksCount > 1
                  ? 'تكلفة الشحن الإجمالية'
                  : 'تكلفة الشحن',
              '${_formatPrice(state.shippingFee)} ج.م',
            ),
          ] else ...[
            _buildInfoRow('اسم السائق', state.driverName),
            SizedBox(height: 8.h),
            _buildInfoRow('رقم لوحة السيارة', state.vehiclePlateNumber),
            SizedBox(height: 8.h),
            _buildInfoRow('رقم رخصة القيادة', state.driverLicenseNumber),
            if (state.expectedPickupDate != null) ...[
              SizedBox(height: 8.h),
              _buildInfoRow(
                'موعد التحميل',
                '${state.expectedPickupDate!.year}/${state.expectedPickupDate!.month}/${state.expectedPickupDate!.day}',
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: ColorManger.primaryLight.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Iconsax.wallet_3,
                  color: ColorManger.primaryLight,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                state.paymentMethod.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          Divider(height: 24.h, color: Colors.grey.shade100),
          _buildInfoRow('طريقة السداد', state.paymentMethod.title),
          if (state.paymentMethod == PaymentMethodType.bankTransfer) ...[
            SizedBox(height: 8.h),
            _buildInfoRow(
              'حالة السداد',
              'سداد بالتحويل بعد موافقة واعتماد إدارة المصنع',
            ),
          ],
          if (state.couponCode != null && state.couponCode!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _buildInfoRow(
              'كوبون الخصم',
              '${state.couponCode} (-${_formatPrice(state.discount)} ج.م)',
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.totalWeightTons > 0) ...[
            _buildSummaryRow(
              'إجمالي وزن الطلبات',
              '${state.totalWeightTons.toStringAsFixed(1)} طن',
            ),
            SizedBox(height: 10.h),
          ],
          _buildSummaryRow(
            'إجمالي سعر المنتجات',
            '${_formatPrice(cartSubtotal)} ج.م',
          ),
          if (state.discount > 0) ...[
            SizedBox(height: 10.h),
            _buildSummaryRow(
              'قيمة الخصم',
              '- ${_formatPrice(state.discount)} ج.م',
              isDiscount: true,
            ),
          ],
          if (state.isWesal && state.shippingFee > 0) ...[
            SizedBox(height: 10.h),
            _buildSummaryRow(
              state.requiredTrucksCount > 1
                  ? 'تكلفة الشحن (${state.requiredTrucksCount} سيارات)'
                  : 'تكلفة الشحن والتوصيل',
              '${_formatPrice(state.shippingFee)} ج.م',
            ),
            if (state.shippingDiscountAmount > 0) ...[
              SizedBox(height: 8.h),
              _buildSummaryRow(
                state.shippingPromotion?.discountPercentage != null
                    ? 'خصم عرض الشحن (${state.shippingPromotion!.discountPercentage!.toInt()}%)'
                    : 'خصم عرض الشحن الترويجي',
                '- ${_formatPrice(state.shippingDiscountAmount)} ج.م',
                isDiscount: true,
              ),
            ],
          ],
          Divider(height: 24.h, color: Colors.grey.shade200),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع النهائي',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                '${_formatPrice(finalTotal)} ج.م',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: ColorManger.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5.sp,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w700,
            color: isDiscount ? Colors.green.shade700 : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
