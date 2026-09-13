import 'package:aleman/core/style/color/color_manger.dart';
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

  const TruckTypeSelectorWidget({
    super.key,
    required this.selectedTruck,
    required this.onTruckSelected,
    required this.currentShippingFee,
    required this.isCalculating,
    this.estimatedDelivery,
    this.totalWeightTons = 0.0,
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
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 12.h),
        ...TruckType.values.map((truck) => _buildTruckCard(truck)),
        if (selectedTruck != null && (currentShippingFee > 0 || isCalculating)) ...[
          SizedBox(height: 10.h),
          _buildShippingSummaryCard(),
        ],
      ],
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

    final isRecommended = totalWeightTons > 0 &&
        truck == TruckType.fromWeight(totalWeightTons);
    final isOverCapacity = totalWeightTons > truck.maxCapacityTons;

    return InkWell(
      onTap: () => onTruckSelected(truck),
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.04)
              : Colors.white,
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
                  Row(
                    children: [
                      Text(
                        truck.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? primary : Colors.black87,
                        ),
                      ),
                      SizedBox(width: 8.w),
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
                      if (isRecommended) ...[
                        SizedBox(width: 6.w),
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
                      ],
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
                        Text(
                          'مناسبة لحمولة سلتك ($totalWeightTons طن)',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ] else if (isOverCapacity) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Iconsax.info_circle,
                          size: 13.sp,
                          color: Colors.orange.shade800,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'حمولة طلبك ($totalWeightTons طن) تفوق السعة',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Container(
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorManger.iconsBackgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManger.primaryLight.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تكلفة الشحن المقدرة للمنطقة',
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
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ],
          ),
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
    );
  }
}
