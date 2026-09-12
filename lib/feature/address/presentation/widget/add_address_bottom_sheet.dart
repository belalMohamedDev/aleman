import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/address/data/model/create_address_request.dart';
import 'package:aleman/feature/address/data/model/egypt_regions.dart';
import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:aleman/feature/address/data/repository/address_repo.dart';
import 'package:aleman/feature/address/logic/cubit/add_address_cubit.dart';
import 'package:aleman/feature/address/logic/cubit/add_address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAddressBottomSheet extends StatelessWidget {
  final ValueChanged<UserAddressModel> onAddressAdded;

  const AddAddressBottomSheet({super.key, required this.onAddressAdded});

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<UserAddressModel> onAddressAdded,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => AddAddressCubit(instance<UserAddressRepository>()),
        child: AddAddressBottomSheet(onAddressAdded: onAddressAdded),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _AddAddressBottomSheetForm(onAddressAdded: onAddressAdded);
  }
}

class _AddAddressBottomSheetForm extends StatefulWidget {
  final ValueChanged<UserAddressModel> onAddressAdded;

  const _AddAddressBottomSheetForm({required this.onAddressAdded});

  @override
  State<_AddAddressBottomSheetForm> createState() =>
      _AddAddressBottomSheetFormState();
}

class _AddAddressBottomSheetFormState
    extends State<_AddAddressBottomSheetForm> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _streetController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _labelController.dispose();
    _streetController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit(
    BuildContext context,
    AddAddressCubit cubit,
    AddAddressState state,
  ) {
    if (!_formKey.currentState!.validate()) return;

    final request = CreateAddressRequest(
      label: _labelController.text.trim(),
      city: state.selectedGovernorate ?? 'الشرقية',
      district: state.selectedCity ?? '',
      street: _streetController.text.trim(),
      notes: _notesController.text.trim(),
    );

    cubit.submitAddress(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddAddressCubit, AddAddressState>(
      listener: (context, state) {
        if (state.isSuccess && state.createdAddress != null) {
          widget.onAddressAdded(state.createdAddress!);
          Navigator.pop(context);
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.successMessage!)));
          }
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddAddressCubit>();
        final governorates = EgyptRegions.governorates;
        final cities = EgyptRegions.getCitiesFor(state.selectedGovernorate);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'إضافة عنوان جديد',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManger.primary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    _buildField(
                      controller: _labelController,
                      label: 'اسم العنوان / العلامة',
                      hint: 'مثال: المزرعة، المصنع، المخزن الرئيسي',
                      required: true,
                    ),
                    SizedBox(height: 10.h),

                    Row(
                      children: [
                        //
                        Expanded(
                          child: _buildDropdownField(
                            label: 'المحافظة',
                            hint: 'اختر المحافظة',
                            value: state.selectedGovernorate,
                            items: governorates,
                            required: true,
                            onChanged: (gov) => cubit.selectGovernorate(gov),
                          ),
                        ),
                        SizedBox(width: 10.w),

                        Expanded(
                          child: _buildDropdownField(
                            label: 'المدينة / المركز',
                            hint: cities.isEmpty
                                ? 'اختر المحافظة أولاً'
                                : 'اختر المركز',
                            value: state.selectedCity,
                            items: cities,
                            required: true,
                            onChanged: (city) => cubit.selectCity(city),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    _buildField(
                      controller: _streetController,
                      label: 'الشارع / الطريق أو تفاصيل الموقع',
                      hint: 'مثال: طريق كفر صقر بجوار كوبري السحارة...',
                      required: true,
                    ),
                    SizedBox(height: 10.h),

                    // ملاحظات إضافية للعنوان
                    _buildField(
                      controller: _notesController,
                      label: 'ملاحظات إضافية للعنوان',
                      hint: 'أي علامات مميزة لتسهيل وصول الشاحنة',
                      maxLines: 2,
                    ),
                    SizedBox(height: 18.h),

                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () => _submit(context, cubit, state),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManger.primaryLight,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: state.isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'حفظ العنوان',
                                style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(fontSize: 12.5.sp, color: Colors.black87),
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null
          : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
        floatingLabelStyle: TextStyle(
          fontSize: 12.5.sp,
          color: ColorManger.primaryLight,
          fontWeight: FontWeight.w600,
        ),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 11.5.sp, color: Colors.grey.shade400),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: ColorManger.primaryLight, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool required = false,
  }) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$label-${items.contains(value) ? value : 'none'}'),
      initialValue: items.contains(value) ? value : null,
      dropdownColor: Colors.white,
      isExpanded: true,
      hint: Text(
        hint,
        style: TextStyle(
          fontSize: 11.5.sp,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.normal,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
        floatingLabelStyle: TextStyle(
          fontSize: 12.5.sp,
          color: ColorManger.primaryLight,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: ColorManger.primaryLight, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      ),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 20.sp,
        color: Colors.grey.shade600,
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(fontSize: 12.5.sp, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      validator: required
          ? (v) => (v == null || v.isEmpty) ? 'يرجى اختيار $label' : null
          : null,
      onChanged: onChanged,
    );
  }
}
