import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/vehicle/data/model/user_vehicle_model.dart';
import 'package:aleman/feature/vehicle/data/repository/vehicle_repo.dart';
import 'package:aleman/feature/vehicle/logic/cubit/vehicle_cubit.dart';
import 'package:aleman/feature/vehicle/logic/cubit/vehicle_state.dart';
import 'package:aleman/feature/vehicle/presentation/widget/add_edit_vehicle_bottom_sheet.dart';
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
        final cubit = context.read<VehicleCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9FB),
          appBar: AppBar(
            title: const Text(
              'سيارات التحميل والسائقين',
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
          body: state.status == VehicleStatus.loading
              ? const Center(child: CircularProgressIndicator())
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
          //     'إضافة سيارة / سائق',
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
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ColorManger.primaryLight.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_shipping_outlined,
                size: 54.sp,
                color: ColorManger.primaryLight,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'لا توجد سيارات أو سائقين محفوظين',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'احفظ بيانات سيارات النقل والسائقين لتسهيل استلام طلباتك من أرض المصنع بضغطة واحدة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
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
              ? ColorManger.buttonColor.withValues(alpha: 0.8)
              : Colors.grey.shade200,
          width: vehicle.isDefault ? 1.5 : 1,
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
                PopupMenuButton<String>(
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert, color: Colors.black54),
                  onSelected: (val) {
                    if (val == 'default') {
                      cubit.setDefaultVehicle(vehicle.id);
                    } else if (val == 'edit') {
                      AddEditVehicleBottomSheet.show(
                        context,
                        vehicleToEdit: vehicle,
                        vehicleCubit: cubit,
                      );
                    } else if (val == 'delete') {
                      _showDeleteDialog(context);
                    }
                  },
                  itemBuilder: (_) => [
                    if (!vehicle.isDefault)
                      const PopupMenuItem(
                        value: 'default',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 18),
                            SizedBox(width: 8),
                            Text('تعيين كافتراضي'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('تعديل'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text('حذف', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 10, color: Colors.grey.shade100),

            SizedBox(height: 3.h),

            // Vehicle Plate Number
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F2F4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
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

            // License if available
            if (vehicle.driverLicenseNumber != null) ...[
              SizedBox(height: 8.h),
              Text(
                'الرقم القومي / الرخصة: ${vehicle.driverLicenseNumber!}',
                style: TextStyle(fontSize: 12.sp, color: Colors.black54),
              ),
            ],

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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('تأكيد الحذف', style: TextStyle(color: Colors.black)),
        content: Text(
          'هل أنت متأكد من حذف بيانات السائق "${vehicle.driverName}" ورقم السيارة "${vehicle.vehiclePlateNumber}"؟',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              cubit.deleteVehicle(vehicle.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
