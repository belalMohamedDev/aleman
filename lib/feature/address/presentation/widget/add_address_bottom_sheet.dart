import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/address/data/model/create_address_request.dart';
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
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _streetController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _labelController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _streetController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, AddAddressCubit cubit) {
    if (!_formKey.currentState!.validate()) return;

    final request = CreateAddressRequest(
      label: _labelController.text.trim(),
      city: _cityController.text.trim(),
      district: _districtController.text.trim(),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage!)),
            );
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
                        Expanded(
                          child: _buildField(
                            controller: _cityController,
                            label: 'المدينة / المركز',
                            hint: 'مثال: فاقوس',
                            required: true,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _buildField(
                            controller: _districtController,
                            label: 'المنطقة / الحي',
                            hint: 'مثال: الصالحية',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    _buildField(
                      controller: _streetController,
                      label: 'الشارع / الطريق أو تفاصيل الموقع',
                      hint: 'مثال: طريق كفر صقر بجوار كوبري...',
                    ),
                    SizedBox(height: 10.h),

                    _buildField(
                      controller: _notesController,
                      label: 'ملاحظات إضافية للعنوان',
                      hint: 'أي علامات مميزة للوصول',
                      maxLines: 2,
                    ),
                    SizedBox(height: 18.h),

                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () => _submit(context, cubit),
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
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null
          : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
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
}
