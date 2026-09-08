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
        Text(
          'اختر طريقة استلام الطلب',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: ColorManger.primary,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                type: OrderType.delivery,
                icon: Iconsax.car5,
                title: 'وصال',
                subtitle: 'المصنع يوصل للعنوان',
                isSelected: selectedType == OrderType.delivery,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildTypeCard(
                type: OrderType.factoryPickup,
                icon: Iconsax.buildings5,
                title: 'أرض المصنع',
                subtitle: 'عربيات العميل تحمل',
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
    final gold = ColorManger.goldDark;

    return InkWell(
      onTap: () => onTypeChanged(type),
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManger.primaryLight.withValues(alpha: 0.01)
              : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? ColorManger.primaryLight.withValues(alpha: 0.3)
                : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.09),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 26.sp,
                  color: isSelected ? primary : Colors.grey.shade600,
                ),
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? primary : Colors.grey.shade400,
                      width: 2,
                    ),
                    color: isSelected ? primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? primary : Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isSelected ? gold : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
