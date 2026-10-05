import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/statsScreen/global_empty_state.dart';
import 'package:aleman/core/statsScreen/global_error.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/vehicle/data/model/user_vehicle_model.dart';
import 'package:aleman/feature/vehicle/data/repository/vehicle_repo.dart';
import 'package:aleman/feature/vehicle/logic/cubit/vehicle_cubit.dart';
import 'package:aleman/feature/vehicle/logic/cubit/vehicle_state.dart';
import 'package:aleman/feature/vehicle/presentation/widget/add_edit_vehicle_bottom_sheet.dart';
import 'package:aleman/feature/vehicle/presentation/widget/vehicles_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class UserVehiclesScreen extends StatelessWidget {
  const UserVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          VehicleCubit(instance<UserVehicleRepository>())..loadVehicles(),
      child: const _UserVehiclesView(),
    );
  }
}

class _UserVehiclesView extends StatelessWidget {
  const _UserVehiclesView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VehicleCubit, VehicleState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<VehicleCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9FB),
          appBar: AppBar(
            title: const Text(
              'سيارات التحميل والسائقين',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFFF9F9FB),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          body: state.status == VehicleStatus.loading
              ? const VehiclesShimmerLoading()
              : state.status == VehicleStatus.error
              ? GlobalError(
                  message: state.errorMessage ?? 'حدث خطأ في تحميل البيانات',
                  onRetry: () => cubit.loadVehicles(),
                )
              : state.vehicles.isEmpty
              ? _buildEmptyState(context, cubit)
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: state.vehicles.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final vehicle = state.vehicles[index];
                    return _VehicleCard(vehicle: vehicle, cubit: cubit);
                  },
                ),

          bottomNavigationBar: _buildBottomBar(context, cubit),
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () {
          //     AddEditVehicleBottomSheet.show(context, vehicleCubit: cubit);
          //   },
          //   backgroundColor: ColorManger.buttonColor,
          //   icon: const Icon(Icons.add, color: Colors.white),
          //   label: const Text(
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, VehicleCubit cubit) {
    return GlobalEmptyState(
      imageAsset: ImageAsset.noCar,
      title: 'لا توجد سيارات أو سائقين محفوظين',
      description: 'احفظ بيانات سيارات النقل والسائقين لتسهيل استلام طلباتك من أرض المصنع بضغطة واحدة',
    );
  }
}

Widget _buildBottomBar(BuildContext context, VehicleCubit cubit) {
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
            AddEditVehicleBottomSheet.show(context, vehicleCubit: cubit);
          },
          icon: Icon(Icons.add, size: 20.sp),
          label: Text(
            'إضافة سيارة / سائق',
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

class _VehicleCard extends StatelessWidget {
  final UserVehicleModel vehicle;
  final VehicleCubit cubit;

  const _VehicleCard({required this.vehicle, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: vehicle.isDefault
              ? ColorManger.primaryLight
              : Colors.grey.shade200,
          width: 0.01,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Driver Name, Default Badge, and Popup menu
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorManger.primaryLight.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Iconsax.truck_fast,
                    color: ColorManger.primaryLight,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              vehicle.driverName,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (vehicle.isDefault) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManger.buttonColor.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'الافتراضي',
                                style: TextStyle(
                                  color: ColorManger.primaryLight,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (vehicle.vehicleType != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          vehicle.vehicleType!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Iconsax.more,
                    color: Colors.grey.shade600,
                    size: 20.sp,
                  ),
                  onPressed: () => _showActionsBottomSheet(context),
                  tooltip: 'خيارات',
                ),
              ],
            ),
            Divider(height: 10, color: Colors.grey.shade100),

            SizedBox(height: 3.h),

            // Vehicle Plate Number
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.pin, size: 15, color: Colors.black54),
                    SizedBox(width: 4.w),
                    Text(
                      vehicle.vehiclePlateNumber,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                if (vehicle.driverPhone != null) ...[
                  SizedBox(width: 12.w),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 14, color: Colors.black54),
                      SizedBox(width: 4.w),
                      Text(
                        vehicle.driverPhone!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            SizedBox(height: 3.h),
            // License if available
            if (vehicle.driverLicenseNumber != null) ...[
              SizedBox(height: 8.h),
              Text(
                'الرقم القومي / الرخصة: ${vehicle.driverLicenseNumber!}',
                style: TextStyle(fontSize: 12.sp, color: Colors.black54),
              ),
            ],
            SizedBox(height: 3.h),
            // Notes if available
            if (vehicle.notes != null && vehicle.notes!.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                'ملاحظات: ${vehicle.notes!}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetCtx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),

                // Header with vehicle & driver info
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: ColorManger.primaryLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Iconsax.truck_fast,
                        color: ColorManger.primaryLight,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.driverName,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'لوحة: ${vehicle.vehiclePlateNumber}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),
                Divider(height: 1, color: Colors.grey.shade100),
                SizedBox(height: 8.h),

                // Option 1: Set Default (if not already default)
                if (!vehicle.isDefault) ...[
                  _buildBottomSheetActionItem(
                    icon: Iconsax.tick_circle,
                    iconColor: ColorManger.primaryLight,
                    iconBgColor: ColorManger.primaryLight.withValues(
                      alpha: 0.1,
                    ),
                    title: 'تعيين كافتراضي',
                    onTap: () {
                      Navigator.pop(bottomSheetCtx);
                      cubit.setDefaultVehicle(vehicle.id);
                    },
                  ),
                  SizedBox(height: 4.h),
                ],

                // Option 2: Edit
                _buildBottomSheetActionItem(
                  icon: Iconsax.edit_2,
                  iconColor: Colors.black87,
                  iconBgColor: Colors.grey.shade100,
                  title: 'تعديل البيانات',
                  onTap: () {
                    Navigator.pop(bottomSheetCtx);
                    AddEditVehicleBottomSheet.show(
                      context,
                      vehicleToEdit: vehicle,
                      vehicleCubit: cubit,
                    );
                  },
                ),
                SizedBox(height: 4.h),

                // Option 3: Delete
                _buildBottomSheetActionItem(
                  icon: Iconsax.trash,
                  iconColor: Colors.red.shade600,
                  iconBgColor: Colors.red.shade50,
                  title: 'حذف السيارة',
                  titleColor: Colors.red.shade600,
                  onTap: () {
                    Navigator.pop(bottomSheetCtx);
                    _showDeleteDialog(context);
                  },
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetActionItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 18.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: titleColor ?? Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 13.sp,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text(
          'تأكيد الحذف',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: Text(
          'هل أنت متأكد من حذف بيانات السائق "${vehicle.driverName}" ورقم السيارة "${vehicle.vehiclePlateNumber}"؟',
          style: TextStyle(color: Colors.black87, fontSize: 13.5.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              cubit.deleteVehicle(vehicle.id);
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
