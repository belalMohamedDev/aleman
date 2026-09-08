// ignore_for_file: deprecated_member_use

import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            Text(
              'عنوان الشحن والتوصيل',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: ColorManger.primary,
              ),
            ),
            TextButton.icon(
              onPressed: onAddNewAddress,
              icon: Icon(Icons.add_location_alt_outlined, size: 18.sp, color: ColorManger.primaryLight),
              label: Text(
                'إضافة عنوان',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.primaryLight,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(Icons.location_off_outlined, size: 36.sp, color: Colors.grey),
          SizedBox(height: 8.h),
          Text(
            'لا توجد عناوين شحن محفوظة بعد',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
          SizedBox(height: 10.h),
          ElevatedButton.icon(
            onPressed: onAddNewAddress,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('أضف عنوان التوصيل الآن'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManger.primaryLight,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
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
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected ? primary.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.shade300,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: address.id,
              groupValue: selectedAddress?.id,
              onChanged: (_) => onAddressSelected(address),
              activeColor: primary,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.label.isNotEmpty ? address.label : 'عنوان التوصيل',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (address.isDefault) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: ColorManger.gold.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            'الافتراضي',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManger.goldDark,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    address.fullAddress,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.location_on,
              color: isSelected ? primary : Colors.grey.shade400,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
