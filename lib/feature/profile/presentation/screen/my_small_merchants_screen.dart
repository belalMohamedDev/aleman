import 'package:aleman/core/style/color/color_manger.dart';
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'عملائي (التجار والموزعين)',
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SmallMerchantsCubit, SmallMerchantsState>(
        builder: (context, state) {
          final filtered = state.filteredMerchants;

          return Column(
            children: [
              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
              //   padding: EdgeInsets.all(16.r),
              //   decoration: BoxDecoration(
              //     // gradient: LinearGradient(
              //     //   colors: [ColorManger.goldDark, ColorManger.gold],
              //     //   begin: Alignment.topRight,
              //     //   end: Alignment.bottomLeft,
              //     // ),
              //     color: ColorManger.primaryLight,
              //     borderRadius: BorderRadius.circular(20.r),
              //     boxShadow: [
              //       BoxShadow(
              //         color: ColorManger.primary.withValues(alpha: 0.25),
              //         blurRadius: 16,
              //         offset: const Offset(0, 6),
              //       ),
              //     ],
              //   ),
              //   child: Row(
              //     children: [
              //       // Container(
              //       //   width: 52.w,
              //       //   height: 52.w,
              //       //   decoration: BoxDecoration(
              //       //     color: Colors.white.withValues(alpha: 0.18),
              //       //     borderRadius: BorderRadius.circular(16.r),
              //       //     border: Border.all(
              //       //       color: Colors.white.withValues(alpha: 0.25),
              //       //     ),
              //       //   ),
              //       //   alignment: Alignment.center,
              //       //   child: Icon(
              //       //     Iconsax.people5,
              //       //     color: Colors.white,
              //       //     size: 26.sp,
              //       //   ),
              //       // ),
              //       SizedBox(width: 14.w),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               'شبكة الموزعين المعتمدين',
              //               style: TextStyle(
              //                 fontSize: 15.sp,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white,
              //               ),
              //             ),
              //             SizedBox(height: 3.h),
              //             Text(
              //               'إدارة التجار الصغار ومتابعة طلباتهم بسهولة',
              //               style: TextStyle(
              //                 fontSize: 11.5.sp,
              //                 color: Colors.white.withValues(alpha: 0.85),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Container(
              //         padding: EdgeInsets.symmetric(
              //           horizontal: 10.w,
              //           vertical: 6.h,
              //         ),
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(14.r),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.black.withValues(alpha: 0.08),
              //               blurRadius: 6,
              //               offset: const Offset(0, 2),
              //             ),
              //           ],
              //         ),
              //         child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Text(
              //               '${state.allMerchants.length}',
              //               style: TextStyle(
              //                 fontSize: 16.sp,
              //                 fontWeight: FontWeight.bold,
              //                 color: ColorManger.primaryLight,
              //                 height: 1.1,
              //               ),
              //             ),
              //             Text(
              //               'تاجر',
              //               style: TextStyle(
              //                 fontSize: 10.sp,
              //                 fontWeight: FontWeight.w600,
              //                 color: Colors.grey.shade600,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // شريط البحث الأنيق (Floating Search Bar)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => cubit.search(val),
                    decoration: InputDecoration(
                      hintText: 'ابحث باسم التاجر، المحل، أو رقم الهاتف...',
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
                              icon: Icon(
                                Icons.close_rounded,
                                size: 18.sp,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                cubit.clearSearch();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 13.h,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState(state.searchQuery)
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final merchant = filtered[index];
                          return _buildMerchantCard(context, merchant);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMerchantCard(BuildContext context, SmallMerchantModel merchant) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: ColorManger.primaryLight.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: ColorManger.primaryLight.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Iconsax.shop,
                          color: ColorManger.primaryLight,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 5.w),

                      Expanded(
                        child: Text(
                          merchant.name,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Icon(
                                Iconsax.call,
                                size: 15.sp,
                                color: ColorManger.primaryLight,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                merchant.phoneNumber,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: merchant.phoneNumber),
                                );
                              },
                              borderRadius: BorderRadius.circular(8.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: ColorManger.primaryLight.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Iconsax.copy,
                                      size: 13.sp,
                                      color: ColorManger.primaryLight,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'نسخ',
                                      style: TextStyle(
                                        fontSize: 11.sp,
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

                        if (merchant.email.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Icon(
                                  Iconsax.sms,
                                  size: 15.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  merchant.email,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
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
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorManger.primaryLight,
                              ColorManger.primaryLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManger.primaryLight.withValues(
                                alpha: 0.25,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.task_square,
                              size: 18.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'عرض أوردرات هذا التاجر',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12.sp,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String searchQuery) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: ColorManger.primaryLight.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Iconsax.people,
                size: 38.sp,
                color: ColorManger.primaryLight,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              searchQuery.isEmpty
                  ? 'لا يوجد تجار تابعين مسجلين حالياً'
                  : 'لا توجد نتائج مطابقة لبحثك',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              searchQuery.isEmpty
                  ? 'سيظهر هنا جميع الموزعين والتجار الصغار التابعين لحسابك التجاري'
                  : 'يرجى التأكد من كتابة اسم التاجر أو رقم هاتفه بشكل صحيح',
              style: TextStyle(
                fontSize: 12.5.sp,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
