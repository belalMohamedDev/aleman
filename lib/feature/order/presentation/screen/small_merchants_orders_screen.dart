import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/statsScreen/global_empty_state.dart';
import 'package:aleman/core/statsScreen/global_error.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/order/cubit/small_merchants_orders_cubit.dart';
import 'package:aleman/feature/order/cubit/small_merchants_orders_state.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:aleman/feature/order/presentation/screen/order_details_screen.dart';
import 'package:aleman/feature/order/presentation/widget/merchant_orders_shimmer_loading.dart';
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
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _isSearching =
        widget.initialSearchQuery != null &&
        widget.initialSearchQuery!.isNotEmpty;
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

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    SmallMerchantsOrdersCubit cubit,
    SmallMerchantsOrdersState state,
  ) {
    if (_isSearching) {
      return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorManger.authTitleDark),
          onPressed: () {
            setState(() => _isSearching = false);
            _searchController.clear();
            cubit.search('');
          },
        ),
        title: SizedBox(
          height: 42.h,
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (val) {
              cubit.search(val);
              setState(() {});
            },
            style: TextStyle(
              fontSize: 13.sp,
              color: ColorManger.authTitleDark,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'ابحث باسم التاجر أو رقم الطلب...',
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
                        cubit.search('');
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                  width: 0.08,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                  width: 0.08,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: ColorManger.primaryLight,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final titleText = widget.merchantName != null
        ? 'أوردرات: ${widget.merchantName}'
        : 'أوردرات العملاء';

    return AppBar(
      title: Text(
        titleText,
        style: TextStyle(
          color: ColorManger.authTitleDark,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: ColorManger.authTitleDark),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Iconsax.search_normal_1,
            color: ColorManger.primaryLight,
            size: 20.sp,
          ),
          tooltip: 'بحث',
          onPressed: () => setState(() => _isSearching = true),
        ),
        SizedBox(width: 4.w),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SmallMerchantsOrdersCubit>();

    return BlocBuilder<SmallMerchantsOrdersCubit, SmallMerchantsOrdersState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9F9FB),
          appBar: _buildAppBar(context, cubit, state),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
                child: Column(
                  children: [
                    _buildStatsRow(state),
                    SizedBox(height: 14.h),
                    _buildTabsToggle(context, state, cubit),
                  ],
                ),
              ),

              Expanded(child: _buildBody(state, cubit)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(SmallMerchantsOrdersState state) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'بانتظار موافقتك',
            count: state.pendingMerchantApprovalCount,
            color: const Color(0xFFB45309),
            bgColor: const Color(0xFFFEF3C7),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildStatCard(
            title: 'الطلبات المُسلّمة',
            count: state.completedCount,
            color: const Color(0xFF15803D),
            bgColor: const Color(0xFFDCFCE7),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildStatCard(
            title: 'الطلبات الملغاة',
            count: state.cancelledCount,
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
    SmallMerchantsOrdersState state,
    SmallMerchantsOrdersCubit cubit,
  ) {
    final pendingCount = state.pendingMerchantApprovalCount;
    final otherCount = state.otherOrdersCount;

    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: Stack(
        children: [
          // Animated sliding pill indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            alignment: state.selectedTab == 0
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.centerEnd,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorManger.primaryLight,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManger.primary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Interactive tab buttons
          Row(
            children: [
              Expanded(
                child: _buildTabButton(
                  title: 'بانتظار موافقتي',
                  icon: Iconsax.timer_1,
                  count: pendingCount,
                  isSelected: state.selectedTab == 0,
                  onTap: () => cubit.changeTab(0),
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  title: 'باقي الأوردرات',
                  icon: Iconsax.document_text,
                  count: otherCount,
                  isSelected: state.selectedTab == 1,
                  onTap: () => cubit.changeTab(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required IconData icon,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
              SizedBox(width: 6.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
              if (count > 0) ...[
                SizedBox(width: 6.w),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.22)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey.shade800,
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
      return const MerchantOrdersShimmerLoading();
    }

    if (state.status == SmallMerchantsOrdersStatus.error &&
        state.orders.isEmpty) {
      return GlobalError(onRetry: () => cubit.loadOrders(refresh: true));
    }

    final filtered = state.filteredOrders;

    if (filtered.isEmpty) {
      final isMerchantFiltered =
          widget.merchantName != null && state.searchQuery.isNotEmpty;
      return GlobalEmptyState(
        imageAsset: ImageAsset.emptyOrder,
        title: isMerchantFiltered
            ? 'لا توجد طلبات مسجلة للتاجر\n«${widget.merchantName}»'
            : (state.searchQuery.isNotEmpty
                  ? 'لا توجد أوردرات مطابقة للبحث'
                  : (state.selectedTab == 0
                        ? 'لا توجد طلبات بانتظار موافقتك حالياً'
                        : 'لا توجد أوردرات مسجلة')),
        description: isMerchantFiltered
            ? 'لم يقم هذا التاجر بإنشاء أي طلبات حتى الآن، أو لم يتم ربط طلباته بحسابه بعد.'
            : (state.selectedTab == 0
                  ? 'أي طلب جديد يُنشئه عملاؤك سيظهر هنا لتتمكن من مراجعته وقبوله أو رفضه.'
                  : 'الطلبات المعتمدة وقيد التنفيذ أو المكتملة ستظهر هنا مباشرة.'),
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

    final displayCustomerName =
        (order.customerName != null &&
            order.customerName!.trim().isNotEmpty &&
            order.customerName!.toLowerCase() != 'string')
        ? order.customerName!
        : (widget.merchantName ?? 'عميل فرعي');

    final displayOrderNum =
        (order.orderNumber.isNotEmpty &&
            order.orderNumber.toLowerCase() != 'string')
        ? order.orderNumber
        : (order.id.isNotEmpty && order.id != '0' ? order.id : '1001');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OrderDetailsScreen(order: order, isParentMerchantView: true),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: EdgeInsets.all(14.w),
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
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.user,
                          size: 13.sp,
                          color: ColorManger.primaryLight,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            displayCustomerName,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManger.primary,
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
                    color: statusColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.28),
                      width: 0.8,
                    ),
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
                _buildDeliveryTypeBadge(order),
                if (order.truckName != null && order.truckName!.isNotEmpty)
                  _buildInfoBadge(
                    icon: Icons.local_shipping_outlined,
                    text: order.truckName!,
                  ),
                if (order.totalWeightTons > 0)
                  _buildInfoBadge(
                    icon: Iconsax.weight_1,
                    text: '${order.totalWeightTons.toStringAsFixed(1)} طن',
                  ),
                if (order.totalItemsCount > 0)
                  _buildInfoBadge(
                    icon: Iconsax.box,
                    text: '${order.totalItemsCount} صنف',
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
            if (order.isPendingMerchantApproval) ...[
              Divider(height: 20.h, color: Colors.grey.shade200),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _confirmApproval(order),
                      icon: Icon(Icons.check_circle_outline, size: 16.sp),
                      label: Text(
                        'اعتماد الطلب',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManger.primaryLight,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showRejectDialog(order),
                      icon: Icon(Icons.highlight_off, size: 16.sp),
                      label: Text(
                        'رفض الطلب',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFDC2626)),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmApproval(OrderResponseModel order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text(
          'اعتماد الطلب',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من اعتماد طلب العميل الفرعي #${order.orderNumber}؟\nسيتم إرسال الطلب تلقائياً لإدارة ومبيعات المصنع لتأكيده وتجهيزه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final cubit = context.read<SmallMerchantsOrdersCubit>();
              await cubit.reviewOrder(orderId: order.id, isApproved: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManger.primaryLight,
            ),
            child: const Text(
              'تأكيد الاعتماد',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(OrderResponseModel order) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text(
          'رفض طلب العميل الفرعي',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الرجاء إدخال سبب الرفض للطلب #${order.orderNumber}:'),
            SizedBox(height: 10.h),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'سبب الرفض (اختياري)...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final cubit = context.read<SmallMerchantsOrdersCubit>();
              await cubit.reviewOrder(
                orderId: order.id,
                isApproved: false,
                rejectionReason: reasonController.text.trim().isEmpty
                    ? null
                    : reasonController.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            child: const Text(
              'تأكيد الرفض',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTypeBadge(OrderResponseModel order) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            order.isWesal ? Iconsax.truck_fast : Iconsax.building_3,
            size: 13.sp,
            color: ColorManger.primaryLight,
          ),
          SizedBox(width: 4.w),
          Text(
            order.orderTypeName,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.bold,
              color: ColorManger.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.5.sp, color: ColorManger.primaryLight),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(int statusCode) {
    switch (statusCode) {
      case 8:
      case 1:
      case 9:
        return const Color(0xFFD97706);
      case 2:
      case 3:
      case 4:
      case 5:
        return ColorManger.primaryLight;
      case 6:
        return const Color(0xFF15803D);
      case 7:
      case 10:
      case 11:
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF64748B);
    }
  }
}
