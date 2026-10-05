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
        // 1. Expected Pickup Date Section (First Priority)
        _buildPickupDateSection(context),

        SizedBox(height: 18.h),

        // 2. Vehicles Section
        _buildVehiclesSection(),
      ],
    );
  }

  // ================= 1. Date Section ================= //
  Widget _buildPickupDateSection(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final dayAfter = DateTime(now.year, now.month, now.day + 2);

    final isTodaySelected =
        expectedPickupDate != null &&
        expectedPickupDate!.year == today.year &&
        expectedPickupDate!.month == today.month &&
        expectedPickupDate!.day == today.day;

    final isTomorrowSelected =
        expectedPickupDate != null &&
        expectedPickupDate!.year == tomorrow.year &&
        expectedPickupDate!.month == tomorrow.month &&
        expectedPickupDate!.day == tomorrow.day;

    final isDayAfterSelected =
        expectedPickupDate != null &&
        expectedPickupDate!.year == dayAfter.year &&
        expectedPickupDate!.month == dayAfter.month &&
        expectedPickupDate!.day == dayAfter.day;

    final isCustomSelected =
        expectedPickupDate != null &&
        !isTodaySelected &&
        !isTomorrowSelected &&
        !isDayAfterSelected;

    final formattedDate = expectedPickupDate != null
        ? '${expectedPickupDate!.year}/${expectedPickupDate!.month}/${expectedPickupDate!.day}'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'موعد التحميل من أرض المصنع',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              if (formattedDate != null)
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primary,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 10.h),

        // Quick Date Options Row
        Row(
          children: [
            Expanded(
              child: _buildDateChip(
                label: 'اليوم',
                sublabel: '${today.day}/${today.month}',
                isSelected: isTodaySelected,
                icon: Iconsax.calendar_tick,
                onTap: () => onDateChanged(today),
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: _buildDateChip(
                label: 'غداً',
                sublabel: '${tomorrow.day}/${tomorrow.month}',
                isSelected: isTomorrowSelected,
                icon: Iconsax.calendar_1,
                onTap: () => onDateChanged(tomorrow),
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: _buildDateChip(
                label: 'بعد غد',
                sublabel: '${dayAfter.day}/${dayAfter.month}',
                isSelected: isDayAfterSelected,
                icon: Iconsax.calendar,
                onTap: () => onDateChanged(dayAfter),
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: _buildDateChip(
                label: isCustomSelected ? 'مخصص' : 'تاريخ آخر',
                sublabel: isCustomSelected
                    ? '${expectedPickupDate!.day}/${expectedPickupDate!.month}'
                    : 'اختيار 📅',
                isSelected: isCustomSelected,
                icon: Iconsax.calendar_edit,
                onTap: () => _openCustomDatePicker(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateChip({
    required String label,
    required String sublabel,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final primary = ColorManger.primaryLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.shade200,
            width: 0.01,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? primary.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? ColorManger.primary : Colors.grey.shade500,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? ColorManger.primary : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 9.sp,
                color: isSelected ? ColorManger.primary : Colors.grey.shade500,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCustomDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          expectedPickupDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorManger.primaryLight,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
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
  }

  // ================= 2. Vehicles Section ================= //
  Widget _buildVehiclesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'سيارة وسائق التحميل',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              InkWell(
                onTap: onAddNewVehicle,
                borderRadius: BorderRadius.circular(20.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.add_circle,
                        size: 16.sp,
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
        ),
        SizedBox(height: 10.h),

        // Body: Empty card or list of vehicles
        if (vehicles.isEmpty)
          _buildEmptyVehicleCard()
        else
          ...vehicles.map((vehicle) => _buildVehicleCard(vehicle)),
      ],
    );
  }

  Widget _buildEmptyVehicleCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200, width: 0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
              Iconsax.truck,
              size: 28.sp,
              color: ColorManger.primaryLight,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'لا توجد سيارات أو سائقين محفوظين بعد',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'أضف بيانات سيارة النقل والسائق لترتيب إذن الدخول والتحميل من المصنع',
            style: TextStyle(fontSize: 11.5.sp, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 40.h,
            child: ElevatedButton(
              onPressed: onAddNewVehicle,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManger.primaryLight,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('أضف سيارة وسائق الآن'),
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
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.h),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio circle
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? primary : Colors.grey.shade300,
                  width: 0.0,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12.w),

            // Vehicle & Driver Info
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
                          color: const Color(0xFF0F172A),
                        ),
                      ),

                      const Spacer(),
                      if (vehicle.vehicleType != null &&
                          vehicle.vehicleType!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            vehicle.vehicleType!,
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Plate and Phone tags
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.tag,
                            size: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            vehicle.vehiclePlateNumber,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),

                      if (vehicle.driverPhone != null &&
                          vehicle.driverPhone!.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        Row(
                          children: [
                            Icon(
                              Iconsax.call,
                              size: 13.sp,
                              color: Colors.grey.shade500,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              vehicle.driverPhone!,
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                color: Colors.grey.shade600,
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
                      'رقم الرخصة: ${vehicle.driverLicenseNumber!}',
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // Truck icon container
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? primary.withValues(alpha: 0.1)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Iconsax.truck,
                color: isSelected ? ColorManger.primary : Colors.grey.shade500,
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
