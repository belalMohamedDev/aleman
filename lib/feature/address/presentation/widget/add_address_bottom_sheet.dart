import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/sharedWidget/app_toast.dart';
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
import 'package:iconsax/iconsax.dart';

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

    if (state.selectedGovernorate == null ||
        state.selectedGovernorate!.trim().isEmpty) {
      AppToast.showError(context, message: 'يرجى اختيار المحافظة أولاً');
      return;
    }

    if (state.selectedCity == null || state.selectedCity!.trim().isEmpty) {
      AppToast.showError(context, message: 'يرجى اختيار المركز أو المدينة');
      return;
    }

    final request = CreateAddressRequest(
      label: _labelController.text.trim(),
      city: state.selectedGovernorate!,
      district: state.selectedCity!,
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
          Navigator.of(context).maybePop();
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddAddressCubit>();
        final governorates = EgyptRegions.governorates;
        final cities = EgyptRegions.getCitiesFor(state.selectedGovernorate);

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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          Iconsax.location_add,
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
                              'إضافة عنوان جديد',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorManger.authTitleDark,
                              ),
                            ),
                            Text(
                              'أدخل بيانات موقعك بدقة لتسهيل وصول الشاحنة',
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

                  // Field 1: Address Label
                  _buildFieldLabel('اسم العنوان / العلامة', isRequired: true),
                  TextFormField(
                    controller: _labelController,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManger.authTitleDark,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'يرجى إدخال اسم العنوان'
                        : null,
                    decoration: _buildInputDecoration(
                      hint: 'مثال: المزرعة، المصنع، المخزن الرئيسي',
                      prefixIcon: Iconsax.tag,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Field 2 & 3: Governorate and City in Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('المحافظة', isRequired: true),
                            _buildPickerField(
                              context: context,
                              label: 'المحافظة',
                              hint: 'اختر المحافظة',
                              prefixIcon: Iconsax.map,
                              value: state.selectedGovernorate,
                              items: governorates,
                              onSelected: (gov) => cubit.selectGovernorate(gov),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel(
                              'المركز / المدينة',
                              isRequired: true,
                            ),
                            _buildPickerField(
                              context: context,
                              label: 'المركز / المدينة',
                              hint: cities.isEmpty
                                  ? 'اختر المحافظة أولاً'
                                  : 'اختر المركز',
                              prefixIcon: Iconsax.buildings,
                              value: state.selectedCity,
                              items: cities,
                              disabled: cities.isEmpty,
                              onSelected: (city) => cubit.selectCity(city),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // Field 4: Street / Details
                  _buildFieldLabel(
                    'الشارع / الطريق أو تفاصيل الموقع',
                    isRequired: true,
                  ),
                  TextFormField(
                    controller: _streetController,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManger.authTitleDark,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'يرجى إدخال تفاصيل العنوان'
                        : null,
                    decoration: _buildInputDecoration(
                      hint: 'مثال: طريق كفر صقر بجوار كوبري السحارة...',
                      prefixIcon: Iconsax.routing,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Field 5: Notes
                  _buildFieldLabel('ملاحظات إضافية للتوصيل (اختياري)'),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorManger.authTitleDark,
                    ),
                    decoration: _buildInputDecoration(
                      hint: 'أي علامات مميزة أو تعليمات خاصة...',
                      prefixIcon: Iconsax.note_text,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Submit Button
                  Container(
                    width: double.infinity,
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
                      onPressed: state.isLoading
                          ? null
                          : () => _submit(context, cubit, state),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManger.primaryLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: state.isLoading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'حفظ العنوان',
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
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.08),
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

  Widget _buildPickerField({
    required BuildContext context,
    required String label,
    required String hint,
    required IconData prefixIcon,
    required String? value,
    required List<String> items,
    required ValueChanged<String> onSelected,
    bool disabled = false,
  }) {
    final hasValue = value != null && value.trim().isNotEmpty;

    return InkWell(
      onTap: disabled
          ? () {
              AppToast.showError(
                context,
                message: 'يرجى اختيار المحافظة أولاً',
              );
            }
          : () {
              _showRegionPickerSheet(
                context: context,
                title: label,
                items: items,
                selectedValue: value,
                onSelected: onSelected,
              );
            },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 0.08),
        ),
        child: Row(
          children: [
            Icon(
              prefixIcon,
              color: hasValue
                  ? ColorManger.primaryLight
                  : const Color(0xFF64748B),
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                hasValue ? value : hint,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: hasValue ? FontWeight.bold : FontWeight.normal,
                  color: hasValue
                      ? ColorManger.authTitleDark
                      : const Color(0xFF94A3B8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 19.sp,
              color: const Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegionPickerSheet({
    required BuildContext context,
    required String title,
    required List<String> items,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetCtx) {
        return _RegionPickerSheetContent(
          title: title,
          items: items,
          selectedValue: selectedValue,
          onSelected: (selected) {
            Navigator.of(bottomSheetCtx).pop();
            onSelected(selected);
          },
        );
      },
    );
  }
}

class _RegionPickerSheetContent extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  const _RegionPickerSheetContent({
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  State<_RegionPickerSheetContent> createState() =>
      _RegionPickerSheetContentState();
}

class _RegionPickerSheetContentState extends State<_RegionPickerSheetContent> {
  final _searchController = TextEditingController();
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where(
              (item) => item.toLowerCase().contains(query.trim().toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.65.sh,
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
      child: Column(
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

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'اختر ${widget.title}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.authTitleDark,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close, color: Colors.black54, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Search Field
          Container(
            height: 42.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 0.08),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filter,
              style: TextStyle(
                fontSize: 13.sp,
                color: ColorManger.authTitleDark,
              ),
              decoration: InputDecoration(
                hintText: 'ابحث عن ${widget.title}...',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ),
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _filter('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 10.h,
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),
          Divider(height: 0.5, color: Colors.grey.shade100),

          // Items List
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.search_status,
                          size: 38.sp,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'لا توجد نتائج تطابق بحثك',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredItems.length,
                    separatorBuilder: (_, _) =>
                        Divider(height: 0.5, color: Colors.grey.shade100),
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = item == widget.selectedValue;

                      return InkWell(
                        onTap: () => widget.onSelected(item),
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorManger.primaryLight.withValues(
                                    alpha: 0.08,
                                  )
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Iconsax.tick_circle
                                    : Icons.circle_outlined,
                                color: isSelected
                                    ? ColorManger.primaryLight
                                    : Colors.grey.shade300,
                                size: 18.sp,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 13.5.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? ColorManger.primaryLight
                                        : ColorManger.authTitleDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
