import 'package:aleman/core/statsScreen/global_empty_state.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/order/presentation/screen/small_merchants_orders_screen.dart';
import 'package:aleman/feature/profile/data/model/user_profile_model.dart';
import 'package:aleman/feature/profile/logic/cubit/small_merchants_cubit.dart';
import 'package:aleman/feature/profile/logic/cubit/small_merchants_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class MySmallMerchantsScreen extends StatelessWidget {
  final List<SmallMerchantModel> merchants;

  const MySmallMerchantsScreen({super.key, required this.merchants});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SmallMerchantsCubit(merchants),
      child: const _MySmallMerchantsView(),
    );
  }
}

class _MySmallMerchantsView extends StatefulWidget {
  const _MySmallMerchantsView();

  @override
  State<_MySmallMerchantsView> createState() => _MySmallMerchantsViewState();
}

class _MySmallMerchantsViewState extends State<_MySmallMerchantsView> {
  late final TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SmallMerchantsCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: _buildAppBar(context, cubit),
      body: BlocBuilder<SmallMerchantsCubit, SmallMerchantsState>(
        builder: (context, state) {
          final filtered = state.filteredMerchants;

          if (filtered.isEmpty) {
            return _buildEmptyState(state.searchQuery);
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final merchant = filtered[index];
              return _buildMerchantCard(context, merchant);
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    SmallMerchantsCubit cubit,
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
            cubit.clearSearch();
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
              hintText: 'ابحث باسم التاجر أو رقم الهاتف...',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),
              prefixIcon: const Icon(
                Iconsax.search_normal,
                color: Color(0xFF64748B),
                size: 18,
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
                        cubit.clearSearch();
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

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        'عملائي (التجار والموزعين)',
        style: TextStyle(
          color: ColorManger.authTitleDark,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
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

  Widget _buildMerchantCard(BuildContext context, SmallMerchantModel merchant) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200, width: 0.01),
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
            // Top Row: Shop Icon, Merchant Name
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: ColorManger.primaryLight.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Iconsax.shop,
                    color: ColorManger.primaryLight,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    merchant.name,
                    style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            Divider(height: 18, color: Colors.grey.shade100),

            // Phone Row with Copy Button
            Row(
              children: [
                const Icon(Iconsax.call, size: 15, color: Colors.black54),
                SizedBox(width: 6.w),
                Text(
                  merchant.phoneNumber,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: merchant.phoneNumber),
                    );
                  },
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManger.primaryLight.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.copy,
                          size: 12.sp,
                          color: ColorManger.primaryLight,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'نسخ',
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManger.primaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Email Row (if available)
            if (merchant.email.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(Iconsax.sms, size: 15, color: Colors.black54),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      merchant.email,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 14.h),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 42.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SmallMerchantsOrdersScreen(
                        merchantName: merchant.name,
                        merchantId: merchant.id,
                      ),
                    ),
                  );
                },
                icon: Icon(Iconsax.task_square, size: 17.sp),
                label: Text(
                  'عرض أوردرات هذا التاجر',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String searchQuery) {
    return GlobalEmptyState(
      imageAsset: searchQuery.isEmpty ? ImageAsset.client : ImageAsset.search,
      title: searchQuery.isEmpty
          ? 'لا يوجد تجار تابعين مسجلين حالياً'
          : 'لا توجد نتائج مطابقة لبحثك',
      description: searchQuery.isEmpty
          ? 'سيظهر هنا جميع الموزعين والتجار الصغار التابعين لحسابك التجاري'
          : 'يرجى التأكد من كتابة اسم التاجر أو رقم هاتفه بشكل صحيح',
    );
  }
}
