import 'package:aleman/core/statsScreen/global_error.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:aleman/feature/wishlist/logic/cubit/wishlist_state.dart';
import 'package:aleman/feature/home/presentation/widget/product_card.dart';
import 'package:aleman/feature/wishlist/presentation/widget/empty_wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistCubit>().getWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF8),
      // appBar: AppBar(
      //   title: Text(
      //     'قائمة المفضلة',
      //     style: TextStyle(
      //       fontSize: 16.sp,
      //       fontWeight: FontWeight.bold,
      //       color: ColorManger.primary,
      //     ),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   elevation: 0.5,
      //   surfaceTintColor: Colors.transparent,
      //   leading: Navigator.of(context).canPop()
      //       ? IconButton(
      //           icon: Icon(
      //             Icons.arrow_back,
      //             color: ColorManger.primary,
      //             size: 22.sp,
      //           ),
      //           onPressed: () => Navigator.of(context).pop(),
      //         )
      //       : null,
      // ),

      body: Padding(
        padding: EdgeInsets.only(top: 45.h),
        child: BlocConsumer<WishlistCubit, WishlistState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == WishlistStatus.loading && state.items.isEmpty) {
              return _buildShimmerGrid();
            }

            if (state.status == WishlistStatus.error && state.items.isEmpty) {
              return GlobalError(
                onRetry: () {
                  context.read<WishlistCubit>().getWishlist();
                },
              );
            }

            if (state.items.isEmpty) {
              return const EmptyWishlistView();
            }

            return RefreshIndicator(
              color: ColorManger.primary,
              backgroundColor: Colors.white,
              onRefresh: () async {
                await context.read<WishlistCubit>().getWishlist();
              },
              child: GridView.builder(
                padding: EdgeInsets.only(
                  left: 14.w,
                  right: 14.w,
                  top: 14.h,
                  bottom: 90.h,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final product = state.items[index].toProductEntity();
                  return TweenAnimationBuilder<double>(
                    key: ValueKey('wishlist_prod_${product.id}'),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(
                      milliseconds: 260 + (index.clamp(0, 6) * 35),
                    ),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      final clampedVal = value.clamp(0.0, 1.0);
                      return Opacity(
                        opacity: clampedVal,
                        child: Transform.translate(
                          offset: Offset(0, (1.0 - clampedVal) * 16),
                          child: child,
                        ),
                      );
                    },
                    child: ProductCard(product: product),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      },
    );
  }
}
