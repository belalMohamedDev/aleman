import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/vehicle/data/model/create_vehicle_request.dart';
import 'package:aleman/feature/vehicle/data/model/user_vehicle_model.dart';
import 'package:aleman/feature/vehicle/logic/cubit/vehicle_cubit.dart';
import 'package:aleman/feature/vehicle/logic/cubit/vehicle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class AddEditVehicleBottomSheet extends StatefulWidget {
  final UserVehicleModel? vehicleToEdit;
  final ValueChanged<UserVehicleModel>? onVehicleSaved;

  const AddEditVehicleBottomSheet({
    super.key,
    this.vehicleToEdit,
    this.onVehicleSaved,
  });

  static Future<void> show(
    BuildContext context, {
    UserVehicleModel? vehicleToEdit,
    ValueChanged<UserVehicleModel>? onVehicleSaved,
    required VehicleCubit vehicleCubit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: vehicleCubit,
        child: AddEditVehicleBottomSheet(
          vehicleToEdit: vehicleToEdit,
          onVehicleSaved: onVehicleSaved,
        ),
      ),
    );
  }

  @override
  State<AddEditVehicleBottomSheet> createState() =>
      _AddEditVehicleBottomSheetState();
}

class _AddEditVehicleBottomSheetState extends State<AddEditVehicleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _driverNameController;
  late final TextEditingController _plateNumberController;
  late final TextEditingController _licenseController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;

  late final ValueNotifier<String?> _selectedVehicleTypeNotifier;
  late final ValueNotifier<bool> _isDefaultNotifier;

  final List<String> _vehicleTypes = [
    'دبابة ',
    'جامبو',
    'تريلا ',
    'نص نقل',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    final v = widget.vehicleToEdit;
    _driverNameController = TextEditingController(text: v?.driverName ?? '');
    _plateNumberController = TextEditingController(
      text: v?.vehiclePlateNumber ?? '',
    );
    _licenseController = TextEditingController(
      text: v?.driverLicenseNumber ?? '',
    );
    _phoneController = TextEditingController(text: v?.driverPhone ?? '');
    _notesController = TextEditingController(text: v?.notes ?? '');
    _selectedVehicleTypeNotifier = ValueNotifier<String?>(v?.vehicleType);
    _isDefaultNotifier = ValueNotifier<bool>(v?.isDefault ?? false);
  }

  @override
  void dispose() {
    _driverNameController.dispose();
    _plateNumberController.dispose();
    _licenseController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _selectedVehicleTypeNotifier.dispose();
    _isDefaultNotifier.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = CreateVehicleRequest(
      driverName: _driverNameController.text.trim(),
      vehiclePlateNumber: _plateNumberController.text.trim(),
      driverLicenseNumber: _licenseController.text.trim().isEmpty
          ? null
          : _licenseController.text.trim(),
      driverPhone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      vehicleType: _selectedVehicleTypeNotifier.value,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      isDefault: _isDefaultNotifier.value,
    );

    final cubit = context.read<VehicleCubit>();
    bool success = false;
    if (widget.vehicleToEdit != null) {
      success = await cubit.updateVehicle(widget.vehicleToEdit!.id, request);
    } else {
      success = await cubit.addVehicle(request);
    }

    if (success && mounted) {
      if (widget.onVehicleSaved != null &&
          cubit.state.createdOrUpdatedVehicle != null) {
        widget.onVehicleSaved!(cubit.state.createdOrUpdatedVehicle!);
      }
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.vehicleToEdit != null;

    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
          ),
          padding: EdgeInsets.only(
            top: 12.h,
            left: 18.w,
            right: 18.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 38.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),

                  // Header with icon and close button
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(7.w),
                        decoration: BoxDecoration(
                          color: ColorManger.primaryLight.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Iconsax.truck_fast,
                          color: ColorManger.primaryLight,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing
                                  ? 'تعديل بيانات السائق والسيارة'
                                  : 'إضافة سيارة وسائق جديد',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorManger.authTitleDark,
                              ),
                            ),
                            Text(
                              'بيانات السائق والشاحنة لتسهيل استلام طلبات المصنع',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: ColorManger.authSubtitleGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black54,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),
                  Divider(height: 0.5, color: Colors.grey.shade50),
                  SizedBox(height: 12.h),

                  // Row 1: Driver Name & Plate Number side-by-side
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('اسم السائق', isRequired: true),
                            TextFormField(
                              controller: _driverNameController,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorManger.authTitleDark,
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'يرجى إدخال اسم السائق';
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                hint: 'محمود أحمد',
                                prefixIcon: Iconsax.user,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('رقم اللوحة', isRequired: true),
                            TextFormField(
                              controller: _plateNumberController,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorManger.authTitleDark,
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'يرجى إدخال اللوحة';
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                hint: 'د ج ب 1542',
                                prefixIcon: Iconsax.status,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // Row 2: Phone Number & License side-by-side
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('هاتف السائق (اختياري)'),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorManger.authTitleDark,
                              ),
                              decoration: _buildInputDecoration(
                                hint: '010XXXXXXXX',
                                prefixIcon: Iconsax.call,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('الرخصة / القومي (اختياري)'),
                            TextFormField(
                              controller: _licenseController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorManger.authTitleDark,
                              ),
                              decoration: _buildInputDecoration(
                                hint: '2950812...',
                                prefixIcon: Iconsax.personalcard,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // Vehicle Type (Single-line horizontal scroll)
                  _buildFieldLabel('نوع الشاحنة / السيارة (اختياري)'),
                  SizedBox(
                    height: 34.h,
                    child: ValueListenableBuilder<String?>(
                      valueListenable: _selectedVehicleTypeNotifier,
                      builder: (context, selectedType, _) {
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _vehicleTypes.length,
                          separatorBuilder: (_, _) => SizedBox(width: 6.w),
                          itemBuilder: (context, index) {
                            final type = _vehicleTypes[index];
                            final isSelected = selectedType == type;
                            return InkWell(
                              onTap: () {
                                _selectedVehicleTypeNotifier.value = isSelected
                                    ? null
                                    : type;
                              },
                              borderRadius: BorderRadius.circular(9.r),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ColorManger.primaryLight.withValues(
                                          alpha: 0.12,
                                        )
                                      : const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(9.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? ColorManger.primaryLight
                                        : const Color(0xFFE2E8F0),
                                    width: isSelected ? 1.2 : 1.0,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      color: isSelected
                                          ? ColorManger.primaryLight
                                          : ColorManger.authTitleDark,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 11.5.sp,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Notes (Single line)
                  _buildFieldLabel('ملاحظات إضافية (اختياري)'),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorManger.authTitleDark,
                    ),
                    decoration: _buildInputDecoration(
                      hint: 'اسم مقاول النقل، مواعيد مفضلة، إلخ...',
                      prefixIcon: Iconsax.note_text,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Default Vehicle Switch (Compact)
                  ValueListenableBuilder<bool>(
                    valueListenable: _isDefaultNotifier,
                    builder: (context, isDefault, _) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.tick_circle,
                              color: isDefault
                                  ? ColorManger.primaryLight
                                  : const Color(0xFF94A3B8),
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'تعيين كسيارة وسائق افتراضي للاستلام من المصنع',
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorManger.authTitleDark,
                                ),
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch.adaptive(
                                value: isDefault,
                                activeTrackColor: ColorManger.primaryLight,
                                activeThumbColor: Colors.white,
                                onChanged: (val) {
                                  _isDefaultNotifier.value = val;
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 14.h),

                  // Submit Button
                  Container(
                    height: 46.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManger.primaryLight.withValues(
                            alpha: 0.22,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: state.isActionLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManger.primaryLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: state.isActionLoading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isEditing ? 'حفظ التعديلات' : 'إضافة السيارة',
                              style: TextStyle(
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h, right: 2.w),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: ColorManger.authTitleDark,
            ),
          ),
          if (isRequired)
            Text(
              ' *',
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF64748B), size: 18.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.08),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(
          color: ColorManger.primaryLight,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
      ),
    );
  }
}
