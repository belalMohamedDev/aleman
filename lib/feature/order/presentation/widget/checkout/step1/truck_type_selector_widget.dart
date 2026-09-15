import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/data/model/calculate_shipping_model.dart';
import 'package:aleman/feature/order/data/model/enums/order_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class TruckTypeSelectorWidget extends StatelessWidget {
  final TruckType? selectedTruck;
  final ValueChanged<TruckType> onTruckSelected;
  final double currentShippingFee;
  final bool isCalculating;
  final String? estimatedDelivery;
  final double totalWeightTons;

  // New multi-truck & promotions props
  final int requiredTrucksCount;
  final double singleTruckFee;
  final double totalOriginalShippingFee;
  final double shippingDiscountAmount;
  final ShippingPromotionInfo? shippingPromotion;
  final Map<int, ShippingPromotionInfo> truckPromotions;
  final ShippingRecommendationModel? shippingRecommendation;
  final ValueChanged<TruckType>? onApplyRecommendation;

  const TruckTypeSelectorWidget({
    super.key,
    required this.selectedTruck,
    required this.onTruckSelected,
    required this.currentShippingFee,
    required this.isCalculating,
    this.estimatedDelivery,
    this.totalWeightTons = 0.0,
    this.requiredTrucksCount = 1,
    this.singleTruckFee = 0.0,
    this.totalOriginalShippingFee = 0.0,
    this.shippingDiscountAmount = 0.0,
    this.shippingPromotion,
    this.truckPromotions = const {},
    this.shippingRecommendation,
    this.onApplyRecommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.truck_fast,
                  size: 19.sp,
                  color: ColorManger.primaryLight,
                ),
                SizedBox(width: 8.w),
                Text(
                  'نوع سيارة الشحن (وصال)',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primary,
                  ),
                ),
              ],
            ),
            if (isCalculating)
              Row(
                children: [
                  SizedBox(
                    width: 14.w,
                    height: 14.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorManger.primaryLight,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'جاري حساب الشحن...',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorManger.goldDark,
                    ),
                  ),
                ],
              ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          'اختر سيارة الشحن المناسبة لحجم حمولتك',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
        ),
        SizedBox(height: 12.h),

        // Smart Savings Recommendation Banner (if choosing a bigger truck saves money)
        if (shippingRecommendation != null &&
            shippingRecommendation!.potentialSavings > 0) ...[
          _buildSmartRecommendationBanner(context),
          SizedBox(height: 12.h),
        ],

        // Truck options
        ...TruckType.values.map((truck) => _buildTruckCard(truck)),

        // Summary Card
        if (selectedTruck != null &&
            (currentShippingFee > 0 || isCalculating)) ...[
          SizedBox(height: 10.h),
          _buildShippingSummaryCard(),
        ],
      ],
    );
  }

  Widget _buildSmartRecommendationBanner(BuildContext context) {
    final rec = shippingRecommendation!;
    TruckType? targetTruck;
    for (final t in TruckType.values) {
      if (t.value == rec.suggestedTruckType) {
        targetTruck = t;
        break;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBE6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFD666), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE58F),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.lamp_charge,
                  size: 16.sp,
                  color: const Color(0xFFD46B08),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'فرصة توفير تكلفة الشحن!',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF873800),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'وفر ${rec.potentialSavings.toInt()} ج.م',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            rec.message.isNotEmpty
                ? rec.message
                : 'بدلاً من استئجار سيارات متعددة، يمكنك اختيار شاحنة (${rec.suggestedTruckName}) لتوفير ${rec.potentialSavings.toInt()} ج.م ونقل طلبك في شحنة واحدة.',
            style: TextStyle(
              fontSize: 11.5.sp,
              color: const Color(0xFF595959),
              height: 1.3,
            ),
          ),
          if (targetTruck != null && onApplyRecommendation != null) ...[
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 36.h,
              child: ElevatedButton.icon(
                onPressed: () => onApplyRecommendation!(targetTruck!),
                icon: Icon(Iconsax.arrow_swap_horizontal, size: 16.sp),
                label: Text(
                  'تبديل إلى ${rec.suggestedTruckName} وتوفير ${rec.potentialSavings.toInt()} ج.م',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA8C16),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTruckCard(TruckType truck) {
    final isSelected = selectedTruck == truck;
    final primary = ColorManger.primaryLight;

    IconData truckIcon;
    switch (truck) {
      case TruckType.dababa:
        truckIcon = Icons.airport_shuttle_outlined;
        break;
      case TruckType.jumbo:
        truckIcon = Icons.local_shipping_outlined;
        break;
      case TruckType.trella:
        truckIcon = Icons.fire_truck_outlined;
        break;
    }

    final isRecommended =
        totalWeightTons > 0 && truck == TruckType.fromWeight(totalWeightTons);
    final isOverCapacity = totalWeightTons > truck.maxCapacityTons;

    // Calculate how many trucks needed for this truck type
    final int calculatedTrucks =
        (totalWeightTons > 0 && truck.maxCapacityTons > 0)
        ? (totalWeightTons / truck.maxCapacityTons).ceil()
        : 1;
    final int truckCount = calculatedTrucks > 0 ? calculatedTrucks : 1;

    final promo = truckPromotions[truck.value] ??
        (shippingPromotion != null &&
                shippingPromotion!.truckType == truck.value
            ? shippingPromotion
            : (isSelected && (shippingDiscountAmount > 0 || shippingPromotion != null)
                ? shippingPromotion
                : null));
    final bool hasPromo = promo != null ||
        (isSelected && shippingDiscountAmount > 0);

    return InkWell(
      onTap: () => onTruckSelected(truck),
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.shade300,
            width: isSelected ? 1.8 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? primary.withValues(alpha: 0.12)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                truckIcon,
                color: isSelected ? primary : Colors.grey.shade700,
                size: 26.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6.w,
                    runSpacing: 4.h,
                    children: [
                      Text(
                        truck.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? primary : Colors.black87,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primary.withValues(alpha: 0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'حتى ${truck.maxCapacityTons.toInt()} طن',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? primary : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      if (isRecommended)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Text(
                            'الموصى بها',
                            style: TextStyle(
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      if (hasPromo) _buildPromoBadge(promo, isSelected),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    truck.description,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  if (isRecommended) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Iconsax.tick_circle,
                          size: 13.sp,
                          color: Colors.green.shade700,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            'مناسبة لحمولة سلتك ($totalWeightTons طن)',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ] else if (isOverCapacity) ...[
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.info_circle,
                                size: 13.sp,
                                color: Colors.orange.shade900,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  'حمولة طلبك ($totalWeightTons طن) تحتاج $truckCount سيارات',
                                  style: TextStyle(
                                    fontSize: 10.5.sp,
                                    color: Colors.orange.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          // if (isSelected && truckCount > 1) ...[
                          //   SizedBox(height: 2.h),
                          //   Text(
                          //     'سعر الشحن سيحسب لـ $truckCount سيارات (الضعف ${truckCount}x)',
                          //     style: TextStyle(
                          //       fontSize: 9.5.sp,
                          //       color: Colors.orange.shade800,
                          //     ),
                          //   ),
                          // ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4.h),
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primary : Colors.grey.shade400,
                  width: isSelected ? 6.r : 1.5.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingSummaryCard() {
    final hasDiscount = shippingDiscountAmount > 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorManger.iconsBackgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorManger.primaryLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    requiredTrucksCount > 1
                        ? 'تكلفة الشحن لـ ($requiredTrucksCount) سيارات'
                        : 'تكلفة الشحن المقدرة للمنطقة',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorManger.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (estimatedDelivery != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      estimatedDelivery!,
                      style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                    ),
                  ],
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (hasDiscount &&
                      totalOriginalShippingFee > currentShippingFee) ...[
                    Text(
                      '${totalOriginalShippingFee.toInt()} ج.م',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                  Text(
                    isCalculating ? '...' : '$currentShippingFee ج.م',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManger.goldDark,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Multiple trucks calculation detail
          if (requiredTrucksCount > 1 && !isCalculating) ...[
            Divider(height: 14.h, color: Colors.grey.shade300),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تفاصيل الحساب:',
                  style: TextStyle(fontSize: 11.sp, color: Colors.black87),
                ),
                Text(
                  singleTruckFee > 0
                      ? '${singleTruckFee.toInt()} ج.م (للسيارة) × $requiredTrucksCount سيارات'
                      : '$requiredTrucksCount سيارات مطلوبة',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManger.primaryLight,
                  ),
                ),
              ],
            ),
          ],

          if (hasDiscount && !isCalculating) ...[
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'وفرت مع عرض الشحن:',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.green.shade700,
                  ),
                ),
                Text(
                  '- ${shippingDiscountAmount.toInt()} ج.م',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPromoBadge(ShippingPromotionInfo? promo, bool isSelected) {
    String badgeText = 'عرض خاص';
    if (promo?.discountPercentage != null && promo!.discountPercentage! > 0) {
      badgeText = 'خصم ${promo.discountPercentage!.toInt()}%';
    } else if (promo?.discountValue != null && promo!.discountValue! > 0) {
      badgeText = 'خصم ${promo.discountValue!.toInt()} ج.م';
    } else if (isSelected &&
        shippingPromotion?.discountPercentage != null &&
        shippingPromotion!.discountPercentage! > 0) {
      badgeText = 'خصم ${shippingPromotion!.discountPercentage!.toInt()}%';
    } else if (isSelected && shippingDiscountAmount > 0) {
      badgeText = 'خصم ${shippingDiscountAmount.toInt()} ج.م';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFFF7043)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Iconsax.flash_15,
            size: 11.sp,
            color: Colors.white,
          ),
          SizedBox(width: 3.w),
          Text(
            badgeText,
            style: TextStyle(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
