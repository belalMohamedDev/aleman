import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class AddressSelectionWidget extends StatelessWidget {
  final List<UserAddressModel> addresses;
  final UserAddressModel? selectedAddress;
  final ValueChanged<UserAddressModel> onAddressSelected;
  final VoidCallback onAddNewAddress;

  const AddressSelectionWidget({
    super.key,
    required this.addresses,
    required this.selectedAddress,
    required this.onAddressSelected,
    required this.onAddNewAddress,
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
                  Iconsax.location,
                  size: 19.sp,
                  color: ColorManger.primaryLight,
                ),
                SizedBox(width: 8.w),
                Text(
                  'عنوان الشحن والتوصيل',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primary,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: onAddNewAddress,
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: ColorManger.primaryLight.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: ColorManger.primaryLight.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.add,
                      size: 15.sp,
                      color: ColorManger.primaryLight,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'إضافة عنوان',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManger.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        if (addresses.isEmpty)
          _buildEmptyAddressCard()
        else
          ...addresses.map((address) => _buildAddressCard(address)),
      ],
    );
  }

  Widget _buildEmptyAddressCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: ColorManger.primaryLight.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.location_slash,
              size: 32.sp,
              color: ColorManger.primaryLight,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'لا توجد عناوين شحن محفوظة بعد',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'أضف عنوان مزرعتك أو مصنعك لتوصيل الأعلاف مباشرة',
            style: TextStyle(fontSize: 11.5.sp, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 40.h,
            child: ElevatedButton.icon(
              onPressed: onAddNewAddress,
              icon: Icon(Iconsax.add, size: 16.sp),
              label: const Text('أضف عنوان التوصيل الآن'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManger.primaryLight,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(UserAddressModel address) {
    final isSelected = selectedAddress?.id == address.id;
    final primary = ColorManger.primaryLight;

    return InkWell(
      onTap: () => onAddressSelected(address),
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.02) : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? primary.withValues(alpha: 0.2)
                : Colors.grey.shade200,
            width: 1,
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
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مؤشر الاختيار (Custom Radio)
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? primary : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 13.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 10.w),

            // تفاصيل العنوان
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.label.isNotEmpty
                            ? address.label
                            : 'عنوان التوصيل',
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? ColorManger.primary
                              : Colors.black87,
                        ),
                      ),
                      if (address.isDefault) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManger.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'الافتراضي',
                            style: TextStyle(
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManger.goldDark,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    address.fullAddress,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: Colors.grey.shade600,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (address.notes != null &&
                      address.notes!.trim().isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      'ملاحظة: ${address.notes!}',
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // أيقونة الموقع
            Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? primary.withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Iconsax.location,
                color: isSelected ? primary : Colors.grey.shade500,
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
