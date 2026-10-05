import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/data/model/enums/order_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class OrderTypeSelector extends StatelessWidget {
  final OrderType selectedType;
  final ValueChanged<OrderType> onTypeChanged;

  const OrderTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'طريقة الاستلام',
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                type: OrderType.delivery,
                icon: Iconsax.truck_fast,
                title: 'وصال',
                subtitle: 'توصيل إلى موقعك',
                isSelected: selectedType == OrderType.delivery,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildTypeCard(
                type: OrderType.factoryPickup,
                icon: Iconsax.buildings,
                title: 'أرض المصنع',
                subtitle: 'تحميل بسياراتك',
                isSelected: selectedType == OrderType.factoryPickup,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required OrderType type,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    final primary = ColorManger.primaryLight;

    return InkWell(
      onTap: () => onTypeChanged(type),
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.shade200,
            width: 0.01,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? primary.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primary.withValues(alpha: 0.1)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    size: 22.sp,
                    color: isSelected
                        ? ColorManger.primary
                        : Colors.grey.shade600,
                  ),
                ),
                Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? primary : Colors.grey.shade300,
                      width: 0.0,
                    ),
                    color: isSelected ? primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF0F172A) : Colors.black87,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
