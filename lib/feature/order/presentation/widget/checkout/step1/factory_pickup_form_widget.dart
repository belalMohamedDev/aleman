import 'package:aleman/core/style/color/color_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FactoryPickupFormWidget extends StatelessWidget {
  final String driverName;
  final String vehiclePlateNumber;
  final String driverLicenseNumber;
  final DateTime? expectedPickupDate;
  final Function({String? name, String? plate, String? license, DateTime? date})
  onInfoChanged;

  const FactoryPickupFormWidget({
    super.key,
    required this.driverName,
    required this.vehiclePlateNumber,
    required this.driverLicenseNumber,
    required this.expectedPickupDate,
    required this.onInfoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Free pickup info banner
        // Container(
        //   padding: EdgeInsets.all(12.w),
        //   decoration: BoxDecoration(
        //     color: ColorManger.chipStageBg,
        //     borderRadius: BorderRadius.circular(12.r),
        //     border: Border.all(color: ColorManger.chipStageBorder),
        //   ),
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.info_outline,
        //         color: ColorManger.chipStage,
        //         size: 22.sp,
        //       ),
        //       SizedBox(width: 10.w),
        //       Expanded(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               'استلام من أرض المصنع (شحن مجاني 0 ج.م)',
        //               style: TextStyle(
        //                 fontSize: 13.sp,
        //                 fontWeight: FontWeight.bold,
        //                 color: ColorManger.chipStage,
        //               ),
        //             ),
        //             SizedBox(height: 2.h),
        //             Text(
        //               'يقوم العميل بإرسال سياراته للتحميل من مصنع آل إيمان. يرجى ملء بيانات السيارة والسائق لترتيب الإذن وتسهيل الدخول.',
        //               style: TextStyle(
        //                 fontSize: 11.sp,
        //                 color: Colors.black87,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(height: 16.h),

        Text(
          'بيانات السائق والسيارة',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: ColorManger.primary,
          ),
        ),
        SizedBox(height: 10.h),
        _buildTextField(
          label: 'اسم السائق',
          hint: 'مثال: محمود أحمد',
          icon: Icons.person_outline,
          initialValue: driverName,
          onChanged: (val) => onInfoChanged(name: val),
        ),
        SizedBox(height: 12.h),
        // Driver Name & Vehicle Plate Number in Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver License Number
            Expanded(
              child: _buildTextField(
                label: 'رقم رخصة القيادة / الرقم القومي',
                hint: 'مثال: 29508121500000',
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
                initialValue: driverLicenseNumber,
                onChanged: (val) => onInfoChanged(license: val),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildTextField(
                label: 'رقم لوحة العربية',
                hint: 'مثال: د ج ب 1542',
                icon: Icons.local_shipping_outlined,
                initialValue: vehiclePlateNumber,
                onChanged: (val) => onInfoChanged(plate: val),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Expected pickup date
        _buildDatePicker(context),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required String initialValue,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        // labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: ColorManger.primaryLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: ColorManger.primaryLight, width: 0.8),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
          onInfoChanged(date: picked);
        }
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: ColorManger.primaryLight,
              size: 20.sp,
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
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: expectedPickupDate != null
                          ? ColorManger.primary
                          : Colors.grey.shade600,
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
