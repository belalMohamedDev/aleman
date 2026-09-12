import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:aleman/feature/address/data/repository/address_repo.dart';
import 'package:aleman/feature/address/logic/cubit/address_cubit.dart';
import 'package:aleman/feature/address/logic/cubit/address_state.dart';
import 'package:aleman/feature/address/presentation/widget/add_address_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class UserAddressesScreen extends StatelessWidget {
  const UserAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AddressCubit(instance<UserAddressRepository>())..loadAddresses(),
      child: const _UserAddressesView(),
    );
  }
}

class _UserAddressesView extends StatelessWidget {
  const _UserAddressesView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressCubit, AddressState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        if (state.actionSuccessMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionSuccessMessage!),
              backgroundColor: ColorManger.primaryLight,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddressCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9FB),
          appBar: AppBar(
            title: const Text(
              'عناويني',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: state.status == AddressStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : state.addresses.isEmpty
              ? _buildEmptyState(context, cubit)
              : RefreshIndicator(
                  onRefresh: cubit.loadAddresses,
                  color: ColorManger.primaryLight,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    itemCount: state.addresses.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final address = state.addresses[index];
                      return _buildAddressCard(context, address, cubit);
                    },
                  ),
                ),
          bottomNavigationBar: _buildBottomBar(context, cubit),
        );
      },
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    UserAddressModel address,
    AddressCubit cubit,
  ) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: address.isDefault
              ? ColorManger.primaryLight.withValues(alpha: 0.4)
              : Colors.grey.shade200,
          width: address.isDefault ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: ColorManger.primaryLight.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Iconsax.location5,
              color: ColorManger.primaryLight,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),

          // Address Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.label,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManger.primary,
                      ),
                    ),
                    if (address.isDefault) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Text(
                          'افتراضي',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  address.fullAddress,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                if (address.notes != null &&
                    address.notes!.trim().isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'ملاحظة: ${address.notes}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Delete Action
          IconButton(
            icon: Icon(Iconsax.trash, color: Colors.red.shade400, size: 20.sp),
            onPressed: () => _confirmDeleteAddress(context, address, cubit),
            tooltip: 'حذف العنوان',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AddressCubit cubit) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: ColorManger.primaryLight.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.location_slash,
                size: 56.sp,
                color: ColorManger.primaryLight,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'لا توجد عناوين مسجلة',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: ColorManger.primary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'أضف عنوان مزرعتك أو مخزنك الآن لتسهيل الشحن والطلب المباشر من المصنع.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, AddressCubit cubit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton.icon(
            onPressed: () {
              AddAddressBottomSheet.show(
                context,
                onAddressAdded: (_) => cubit.loadAddresses(),
              );
            },
            icon: Icon(Icons.add_location_alt_outlined, size: 20.sp),
            label: Text(
              'إضافة عنوان جديد',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManger.primaryLight,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteAddress(
    BuildContext context,
    UserAddressModel address,
    AddressCubit cubit,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text(
          'حذف العنوان',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: Text('هل أنت متأكد من رغبتك في حذف "${address.label}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.deleteAddress(address.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
