// ignore_for_file: deprecated_member_use

import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/data/model/enums/order_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TruckTypeSelectorWidget extends StatelessWidget {
  final TruckType? selectedTruck;
  final ValueChanged<TruckType> onTruckSelected;
  final double currentShippingFee;
  final bool isCalculating;
  final String? estimatedDelivery;

  const TruckTypeSelectorWidget({
    super.key,
    required this.selectedTruck,
    required this.onTruckSelected,
    required this.currentShippingFee,
    required this.isCalculating,
    this.estimatedDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'نوع سيارة الشحن (وصال)',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: ColorManger.primary,
              ),
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
        SizedBox(height: 10.h),
        ...TruckType.values.map((truck) => _buildTruckCard(truck)),
        if (selectedTruck != null) ...[
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

    return InkWell(
      onTap: () => onTruckSelected(truck),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.shade300,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isSelected ? primary.withOpacity(0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.r),
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
                  Text(
                    truck.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? primary : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    truck.description,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Radio<TruckType>(
              value: truck,
              groupValue: selectedTruck,
              onChanged: (_) => onTruckSelected(truck),
              activeColor: primary,
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
        color: ColorManger.iconsBackgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManger.primaryLight.withOpacity(0.3)),
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
