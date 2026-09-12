import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/vehicle/data/model/user_vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class FactoryPickupFormWidget extends StatelessWidget {
  final List<UserVehicleModel> vehicles;
  final UserVehicleModel? selectedVehicle;
  final ValueChanged<UserVehicleModel> onVehicleSelected;
  final DateTime? expectedPickupDate;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onAddNewVehicle;

  const FactoryPickupFormWidget({
    super.key,
    required this.vehicles,
    required this.selectedVehicle,
    required this.onVehicleSelected,
    required this.expectedPickupDate,
    required this.onDateChanged,
    required this.onAddNewVehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
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
                  'سيارة وسائق التحميل',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primary,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: onAddNewVehicle,
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
                      'إضافة سيارة',
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

        // Body: Empty card or list of vehicles
        if (vehicles.isEmpty)
          _buildEmptyVehicleCard()
        else
          ...vehicles.map((vehicle) => _buildVehicleCard(vehicle)),

        SizedBox(height: 14.h),

        // Expected Pickup Date
        Text(
          'موعد التحميل المتوقع',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: ColorManger.primary,
          ),
        ),
        SizedBox(height: 8.h),
        _buildDatePicker(context),
      ],
    );
  }

  Widget _buildEmptyVehicleCard() {
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
              Icons.local_shipping_outlined,
              size: 32.sp,
              color: ColorManger.primaryLight,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'لا توجد سيارات أو سائقين محفوظين بعد',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'أضف بيانات سيارة النقل والسائق لترتيب إذن الدخول والتحميل من أرض المصنع',
            style: TextStyle(fontSize: 11.5.sp, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 40.h,
            child: ElevatedButton.icon(
              onPressed: onAddNewVehicle,
              icon: Icon(Iconsax.add, size: 16.sp),
              label: const Text('أضف سيارة وسائق الآن'),
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

  Widget _buildVehicleCard(UserVehicleModel vehicle) {
    final isSelected = selectedVehicle?.id == vehicle.id;
    final primary = ColorManger.primaryLight;

    return InkWell(
      onTap: () => onVehicleSelected(vehicle),
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
                ? primary.withValues(alpha: 0.4)
                : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
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

            // تفاصيل السيارة والسائق
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        vehicle.driverName,
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? primary : Colors.black87,
                        ),
                      ),
                      if (vehicle.isDefault) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                ColorManger.buttonColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'الافتراضي',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManger.primaryLight,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (vehicle.vehicleType != null &&
                          vehicle.vehicleType!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F2F4),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            vehicle.vehicleType!,
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // رقم اللوحة
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F2F4),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.pin, size: 13.sp, color: Colors.black54),
                            SizedBox(width: 4.w),
                            Text(
                              vehicle.vehiclePlateNumber,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (vehicle.driverPhone != null &&
                          vehicle.driverPhone!.isNotEmpty) ...[
                        SizedBox(width: 10.w),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 13.sp,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              vehicle.driverPhone!,
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),

                  if (vehicle.driverLicenseNumber != null &&
                      vehicle.driverLicenseNumber!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'الرقم القومي / الرخصة: ${vehicle.driverLicenseNumber!}',
                      style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final formattedDate = expectedPickupDate != null
        ? '${expectedPickupDate!.year}/${expectedPickupDate!.month}/${expectedPickupDate!.day}'
        : 'اختر الموعد المفضل للتحميل';

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: ColorManger.primaryLight,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: ColorManger.primaryLight,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onDateChanged(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 20.sp,
              color: ColorManger.primaryLight,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'موعد التحميل المتوقع',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: expectedPickupDate != null
                          ? Colors.black87
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
