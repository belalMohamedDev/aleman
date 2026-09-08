import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/order/cubit/small_merchants_orders_cubit.dart';
import 'package:aleman/feature/order/cubit/small_merchants_orders_state.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:aleman/feature/order/presentation/screen/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class SmallMerchantsOrdersScreen extends StatelessWidget {
  final String? initialSearchQuery;
  final String? merchantName;
  final String? merchantId;

  const SmallMerchantsOrdersScreen({
    super.key,
    this.initialSearchQuery,
    this.merchantName,
    this.merchantId,
  });

  @override
  Widget build(BuildContext context) {
    final query = merchantName ?? initialSearchQuery;

    return BlocProvider(
      create: (_) {
        final cubit = SmallMerchantsOrdersCubit(instance<OrderRepository>())
          ..loadOrders();
        if (query != null && query.isNotEmpty) {
          cubit.search(query);
        }
        return cubit;
      },
      child: _SmallMerchantsOrdersView(
        initialSearchQuery: query,
        merchantName: merchantName,
      ),
    );
  }
}

class _SmallMerchantsOrdersView extends StatefulWidget {
  final String? initialSearchQuery;
  final String? merchantName;

  const _SmallMerchantsOrdersView({this.initialSearchQuery, this.merchantName});

  @override
  State<_SmallMerchantsOrdersView> createState() =>
      _SmallMerchantsOrdersViewState();
}

class _SmallMerchantsOrdersViewState extends State<_SmallMerchantsOrdersView> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.initialSearchQuery ?? '',
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SmallMerchantsOrdersCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SmallMerchantsOrdersCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'أوردرات العملاء',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SmallMerchantsOrdersCubit, SmallMerchantsOrdersState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => cubit.search(val),
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم التاجر أو رقم الطلب...',
                    hintStyle: TextStyle(
                      fontSize: 12.5.sp,
                      color: Colors.grey.shade400,
                    ),
                    prefixIcon: Icon(
                      Iconsax.search_normal_1,
                      size: 18.sp,
                      color: ColorManger.primaryLight,
                    ),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              cubit.search('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: ColorManger.primaryLight,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 12.h),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'الكل',
                        icon: Iconsax.element_4,
                        count: state.totalFilteredCount,
                        isSelected: state.selectedStatus == null,
                        onTap: () => cubit.filterByStatus(null),
                      ),
                      SizedBox(width: 8.w),
                      _buildFilterChip(
                        label: 'جديدة',
                        icon: Iconsax.clock,
                        count: state.pendingCount,
                        isSelected: state.selectedStatus == 1,

                        onTap: () => cubit.filterByStatus(1),
                      ),
                      SizedBox(width: 8.w),
                      _buildFilterChip(
                        label: 'قيد التنفيذ',
                        icon: Iconsax.box_time,
                        count: state.inProgressCount,
                        isSelected: state.selectedStatus == 2,

                        onTap: () => cubit.filterByStatus(2),
                      ),
                      SizedBox(width: 8.w),
                      _buildFilterChip(
                        label: 'مكتملة',
                        icon: Iconsax.tick_circle,
                        count: state.completedCount,
                        isSelected: state.selectedStatus == 6,

                        onTap: () => cubit.filterByStatus(6),
                      ),
                      SizedBox(width: 8.w),
                      _buildFilterChip(
                        label: 'ملغاة',
                        icon: Iconsax.close_circle,
                        count: state.cancelledCount,
                        isSelected: state.selectedStatus == 7,

                        onTap: () => cubit.filterByStatus(7),
                      ),
                    ],
                  ),
                ),
              ),

              // if (widget.merchantName != null && state.searchQuery.isNotEmpty)
              //   Container(
              //     color: Colors.white,
              //     padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
              //     child: Container(
              //       padding: EdgeInsets.symmetric(
              //         horizontal: 12.w,
              //         vertical: 8.h,
              //       ),
              //       decoration: BoxDecoration(
              //         color: ColorManger.primaryLight.withValues(alpha: 0.08),
              //         borderRadius: BorderRadius.circular(10.r),
              //         border: Border.all(
              //           color: ColorManger.primaryLight.withValues(alpha: 0.25),
              //         ),
              //       ),
              //       child: Row(
              //         children: [
              //           Icon(
              //             Iconsax.shop,
              //             size: 16.sp,
              //             color: ColorManger.primaryLight,
              //           ),
              //           SizedBox(width: 8.w),
              //           Expanded(
              //             child: Text(
              //               'تصفية طلبات: ${widget.merchantName}',
              //               style: TextStyle(
              //                 fontSize: 12.sp,
              //                 fontWeight: FontWeight.bold,
              //                 color: ColorManger.primaryLight,
              //               ),
              //               maxLines: 1,
              //               overflow: TextOverflow.ellipsis,
              //             ),
              //           ),
              //           InkWell(
              //             onTap: () {
              //               _searchController.clear();
              //               cubit.search('');
              //             },
              //             child: Container(
              //               padding: EdgeInsets.symmetric(
              //                 horizontal: 8.w,
              //                 vertical: 3.h,
              //               ),
              //               decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.circular(6.r),
              //                 border: Border.all(color: Colors.grey.shade300),
              //               ),
              //               child: Row(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   Icon(
              //                     Icons.close_rounded,
              //                     size: 13.sp,
              //                     color: Colors.grey.shade700,
              //                   ),
              //                   SizedBox(width: 3.w),
              //                   Text(
              //                     'عرض الكل',
              //                     style: TextStyle(
              //                       fontSize: 11.sp,
              //                       fontWeight: FontWeight.bold,
              //                       color: Colors.grey.shade700,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              Divider(height: 1, color: Colors.grey.shade200),

              Expanded(child: _buildBody(state, cubit)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
    Color? accentColor,
  }) {
    final activeColor = accentColor ?? ColorManger.primaryLight;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isSelected ? activeColor : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14.sp,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              SizedBox(width: 5.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                ),
              ),
              if (count > 0) ...[
                SizedBox(width: 6.w),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.25)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : (accentColor ?? ColorManger.primaryLight),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    SmallMerchantsOrdersState state,
    SmallMerchantsOrdersCubit cubit,
  ) {
    if (state.status == SmallMerchantsOrdersStatus.loading &&
        state.orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == SmallMerchantsOrdersStatus.error &&
        state.orders.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.danger, size: 44.sp, color: Colors.red.shade400),
              SizedBox(height: 12.h),
              Text(
                state.errorMessage ?? 'حدث خطأ أثناء جلب أوردرات العملاء',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14.h),
              ElevatedButton.icon(
                onPressed: () => cubit.loadOrders(refresh: true),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManger.primaryLight,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final filtered = state.filteredOrders;

    if (filtered.isEmpty) {
      final isMerchantFiltered =
          widget.merchantName != null && state.searchQuery.isNotEmpty;
      return Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: ColorManger.primaryLight.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isMerchantFiltered ? Iconsax.shop : Iconsax.box,
                  size: 42.sp,
                  color: ColorManger.primaryLight,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                isMerchantFiltered
                    ? 'لا توجد طلبات مسجلة للتاجر\n«${widget.merchantName}»'
                    : (state.searchQuery.isNotEmpty ||
                              state.selectedStatus != null
                          ? 'لا توجد أوردرات مطابقة للبحث أو الفلتر'
                          : 'لا توجد أوردرات لعملائك حتى الآن'),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.primaryLight,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                isMerchantFiltered
                    ? 'لم يقم هذا التاجر بإنشاء أي طلبات حتى الآن، أو لم يتم ربط طلباته بحسابه بعد.'
                    : 'الطلبات المنشأة بواسطة التجار الصغار التابعين لك ستظهر هنا مباشرة.',
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
              // if (isMerchantFiltered ||
              //     state.searchQuery.isNotEmpty ||
              //     state.selectedStatus != null) ...[
              //   SizedBox(height: 18.h),
              //   OutlinedButton.icon(
              //     onPressed: () {
              //       _searchController.clear();
              //       cubit.search('');
              //       cubit.filterByStatus(null);
              //     },
              //     icon: const Icon(Icons.refresh_rounded, size: 16),
              //     label: const Text('عرض جميع أوردرات التجار'),
              //     style: OutlinedButton.styleFrom(
              //       foregroundColor: ColorManger.primaryLight,
              //       side: BorderSide(color: ColorManger.primaryLight),
              //       padding: EdgeInsets.symmetric(
              //         horizontal: 16.w,
              //         vertical: 10.h,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.r),
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => cubit.loadOrders(refresh: true),
      color: ColorManger.primaryLight,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        itemCount:
            filtered.length +
            (state.status == SmallMerchantsOrdersStatus.loadingMore ? 1 : 0),
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          if (index == filtered.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          final order = filtered[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderResponseModel order) {
    final statusColor = _getStatusColor(order.statusCode);
    final statusBgColor = _getStatusBgColor(order.statusCode);

    final displayCustomerName =
        (order.customerName != null &&
            order.customerName!.trim().isNotEmpty &&
            order.customerName!.toLowerCase() != 'string')
        ? order.customerName!
        : (widget.merchantName ?? 'تاجر محلي');

    final displayOrderNum =
        (order.orderNumber.isNotEmpty &&
            order.orderNumber.toLowerCase() != 'string')
        ? order.orderNumber
        : (order.id.isNotEmpty && order.id != '0' ? order.id : '1001');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManger.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.user,
                          size: 14.sp,
                          color: ColorManger.primaryLight,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            displayCustomerName,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManger.primaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'طلب #$displayOrderNum',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                if (order.createdAt != null)
                  Text(
                    '${order.createdAt!.year}/${order.createdAt!.month.toString().padLeft(2, '0')}/${order.createdAt!.day.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10.h),
            const Divider(height: 0.1, thickness: 0.2),
            SizedBox(height: 10.h),

            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: [
                _buildInfoBadge(
                  icon: order.isWesal ? Iconsax.car : Iconsax.buildings,
                  text: order.orderTypeName,
                  color: Colors.grey.shade700,
                  bgColor: Colors.grey.shade100,
                ),
                if (order.truckName != null && order.truckName!.isNotEmpty)
                  _buildInfoBadge(
                    icon: Icons.local_shipping_outlined,
                    text: order.truckName!,
                    color: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                  ),
                if (order.totalWeightTons > 0)
                  _buildInfoBadge(
                    icon: Iconsax.weight_1,
                    text: '${order.totalWeightTons.toStringAsFixed(1)} طن',
                    color: const Color(0xFF059669),
                    bgColor: const Color(0xFFECFDF5),
                  ),
                if (order.totalItemsCount > 0)
                  _buildInfoBadge(
                    icon: Iconsax.box,
                    text: '${order.totalItemsCount} صنف',
                    color: Colors.grey.shade700,
                    bgColor: Colors.grey.shade100,
                  ),
              ],
            ),
            SizedBox(height: 12.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الإجمالي',
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      '${order.total.toStringAsFixed(0)} ج.م',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManger.primary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'عرض التفاصيل',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManger.primaryLight,
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

  Widget _buildInfoBadge({
    required IconData icon,
    required String text,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(int statusCode) {
    switch (statusCode) {
      case 1:
        return const Color(0xFFD97706);
      case 2:
      case 3:
      case 4:
      case 5:
        return const Color(0xFF2563EB);
      case 6:
        return const Color(0xFF059669);
      case 7:
        return const Color(0xFFDC2626);
      default:
        return Colors.grey.shade700;
    }
  }

  Color _getStatusBgColor(int statusCode) {
    switch (statusCode) {
      case 1:
        return const Color(0xFFFEF3C7);
      case 2:
      case 3:
      case 4:
      case 5:
        return const Color(0xFFEFF6FF);
      case 6:
        return const Color(0xFFECFDF5);
      case 7:
        return const Color(0xFFFEE2E2);
      default:
        return Colors.grey.shade100;
    }
  }
}
