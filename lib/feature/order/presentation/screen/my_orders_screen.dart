import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/cubit/orders_cubit.dart';
import 'package:aleman/feature/order/cubit/orders_state.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:aleman/feature/order/presentation/screen/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit(instance<OrderRepository>())..loadOrders(),
      child: const _MyOrdersView(),
    );
  }
}

class _MyOrdersView extends StatelessWidget {
  const _MyOrdersView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        if (state.actionMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionMessage!),
              backgroundColor: ColorManger.primaryLight,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<OrdersCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9FB),
          appBar: AppBar(
            title: const Text(
              'طلباتي',
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
          body: state.status == OrdersStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: cubit.loadOrders,
                  color: ColorManger.primaryLight,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsRow(state),
                        SizedBox(height: 18.h),

                        _buildTabsToggle(context, state, cubit),
                        SizedBox(height: 16.h),

                        if (state.filteredOrders.isEmpty)
                          _buildEmptyOrdersState(state.selectedTab)
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.filteredOrders.length,
                            separatorBuilder: (_, _) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final order = state.filteredOrders[index];
                              return _buildOrderCard(context, order);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildStatsRow(OrdersState state) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'الطلبات المعلقة',
            count: state.activeOrdersCount,
            color: const Color(0xFFB45309),
            bgColor: const Color(0xFFFEF3C7),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildStatCard(
            title: 'الطلبات المُسلّمة',
            count: state.completedOrdersCount,
            color: const Color(0xFF15803D),
            bgColor: const Color(0xFFDCFCE7),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildStatCard(
            title: 'الطلبات الملغاة',
            count: state.cancelledOrdersCount,
            color: const Color(0xFFB91C1C),
            bgColor: const Color(0xFFFEE2E2),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsToggle(
    BuildContext context,
    OrdersState state,
    OrdersCubit cubit,
  ) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              title: 'الطلبات الحالية',
              isSelected: state.selectedTab == 0,
              onTap: () => cubit.changeTab(0),
            ),
          ),
          Expanded(
            child: _buildTabButton(
              title: 'الطلبات السابقة',
              isSelected: state.selectedTab == 1,
              onTap: () => cubit.changeTab(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? ColorManger.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderResponseModel order) {
    final statusColor = _getStatusColor(order.statusCode);

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
        );
        if (context.mounted) {
          context.read<OrdersCubit>().loadOrders();
        }
      },
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: ColorManger.primaryLight.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Iconsax.box,
                        size: 16.sp,
                        color: ColorManger.primaryLight,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'الطلب #${order.orderNumber.isNotEmpty ? order.orderNumber : order.id.substring(0, 8)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManger.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: order.isWesal
                        ? Colors.blue.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        order.isWesal ? Iconsax.car5 : Iconsax.building_35,
                        size: 12.sp,
                        color: order.isWesal
                            ? Colors.blue.shade700
                            : Colors.orange.shade800,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        order.orderTypeName,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: order.isWesal
                              ? Colors.blue.shade700
                              : Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 18.h, color: Colors.grey.shade100),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order.totalWeightTons > 0) ...[
                      Text(
                        'إجمالي الكمية: ${order.totalWeightTons} طن',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                    Text(
                      order.createdAt != null
                          ? '${order.createdAt!.year}/${order.createdAt!.month}/${order.createdAt!.day}'
                          : 'اليوم',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الإجمالي',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      '${order.total} ج.م',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManger.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Footer: شارة الحالة + زر السهم للتفاصيل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'التفاصيل',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorManger.primaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12.sp,
                      color: ColorManger.primaryLight,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyOrdersState(int selectedTab) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 100.h, horizontal: 24.w),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(22.r),
              decoration: BoxDecoration(
                color: ColorManger.primaryLight.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.box_remove,
                size: 50.sp,
                color: ColorManger.primaryLight,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              selectedTab == 0
                  ? 'لا توجد طلبات جارية حالياً'
                  : 'لا توجد طلبات سابقة',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: ColorManger.primary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              selectedTab == 0
                  ? 'أي طلب جديد تقوم بإنشائه سيظهر هنا لمتابعة خط سير التجهيز والشحن.'
                  : 'جميع طلباتك المكتملة أو الملغاة ستظهر هنا في سجلك الدائم.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(int statusCode) {
    switch (statusCode) {
      case 1:
        return const Color(0xFFD97706); // قيد الانتظار (أصفر كهرماني)
      case 2:
        return const Color(0xFF2563EB); // تم التأكيد (أزرق)
      case 3:
        return const Color(0xFF7C3AED); // قيد التجهيز (بنفسجي)
      case 4:
      case 5:
        return const Color(
          0xFF0D9488,
        ); // خرج للتوصيل / جاهز للتحميل (سماوي مائل للأخضر)
      case 6:
        return const Color(0xFF16A34A); // مكتمل (أخضر)
      case 7:
        return const Color(0xFFDC2626); // ملغي (أحمر)
      default:
        return Colors.grey.shade700;
    }
  }
}
