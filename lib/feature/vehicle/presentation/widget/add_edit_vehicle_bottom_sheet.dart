import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/vehicle/data/model/create_vehicle_request.dart';
import 'package:aleman/feature/vehicle/data/model/user_vehicle_model.dart';
import 'package:aleman/feature/vehicle/logic/cubit/vehicle_cubit.dart';
import 'package:aleman/feature/vehicle/logic/cubit/vehicle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  // Local state managed via ValueNotifiers instead of setState
  late final ValueNotifier<String?> _selectedVehicleTypeNotifier;
  late final ValueNotifier<bool> _isDefaultNotifier;

  final List<String> _vehicleTypes = [
    'دبابة (حتى 3 طن)',
    'جامبو (حتى 6 طن)',
    'تريلا (حتى 25 طن)',
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
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.vehicleToEdit != null;

    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.only(
              top: 20.h,
              left: 20.w,
              right: 20.w,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
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
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing
                              ? 'تعديل بيانات السائق والسيارة'
                              : 'إضافة سيارة وسائق جديد',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.black54),
                        ),
                      ],
                    ),
                    // const Divider(),
                    SizedBox(height: 12.h),

                    // Driver Name
                    TextFormField(
                      controller: _driverNameController,
                      decoration: InputDecoration(
                        labelText: 'اسم السائق *',
                        hintText: 'مثال: محمود أحمد حسن',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'يرجى إدخال اسم السائق';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),

                    // Plate Number
                    TextFormField(
                      controller: _plateNumberController,
                      decoration: InputDecoration(
                        labelText: 'رقم لوحة السيارة *',
                        hintText: 'مثال: د ج ب 1542',
                        prefixIcon: const Icon(Icons.local_shipping_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'يرجى إدخال رقم لوحة السيارة';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),

                    // License / National ID
                    TextFormField(
                      controller: _licenseController,
                      decoration: InputDecoration(
                        labelText: 'رقم الرخصة أو الرقم القومي (اختياري)',
                        hintText: 'مثال: 295081215...',
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'رقم هاتف السائق للتنسيق (اختياري)',
                        hintText: '010XXXXXXXX',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Vehicle Type (Managed without setState via ValueListenableBuilder)
                    Text(
                      'نوع الشاحنة / السيارة',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ValueListenableBuilder<String?>(
                      valueListenable: _selectedVehicleTypeNotifier,
                      builder: (context, selectedType, _) {
                        return Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: _vehicleTypes.map((type) {
                            final isSelected = selectedType == type;
                            return ChoiceChip(
                              label: Text(type),
                              selected: isSelected,
                              selectedColor: ColorManger.buttonColor.withValues(
                                alpha: 0.2,
                              ),
                              // disabledColor: ColorManger.chipForm,
                              backgroundColor: ColorManger.backgroundItem,

                              labelStyle: TextStyle(
                                color: isSelected
                                    ? ColorManger.primaryLight
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12.sp,
                              ),
                              onSelected: (selected) {
                                _selectedVehicleTypeNotifier.value = selected
                                    ? type
                                    : null;
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                    SizedBox(height: 14.h),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'ملاحظات إضافية (اختياري)',
                        hintText: 'اسم مقاول النقل، مواعيد مفضلة، إلخ...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Is Default (Managed without setState via ValueListenableBuilder)
                    ValueListenableBuilder<bool>(
                      valueListenable: _isDefaultNotifier,
                      builder: (context, isDefault, _) {
                        return InkWell(
                          onTap: () {
                            _isDefaultNotifier.value =
                                !_isDefaultNotifier.value;
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: Checkbox(
                                    value: isDefault,
                                    activeColor: ColorManger.buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (val) {
                                      _isDefaultNotifier.value = val ?? false;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    'تعيين كمركبة وسائق افتراضي لتحميل أرض المصنع',
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Submit Button
                    SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: state.isActionLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManger.primaryLight,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: state.isActionLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEditing ? 'حفظ التعديلات' : 'إضافة السيارة',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
