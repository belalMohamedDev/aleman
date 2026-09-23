import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/statsScreen/global_error.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/core/utils/cart_animation_helper.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_state.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/refactor/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartCubit>().getCartCount();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
        builder: (context, state) {
          final showLoginPrompt = state.showLoginPrompt;

          return Scaffold(
            body: Stack(
              children: [
                RefreshIndicator(
                  color: ColorManger.primary,
                  backgroundColor: ColorManger.white,
                  onRefresh: () async {
                    await Future.wait([
                      context.read<HomeCuibtCubit>().fetchHomeData(),
                      context.read<CartCubit>().getCartCount(),
                    ]);
                  },
                  child:
                      (state.bannersError != null &&
                          state.categoriesError != null &&
                          state.productsError != null)
                      ? Padding(
                          padding: EdgeInsets.only(top: 120.h),
                          child: GlobalError(onTap: () {}),
                        )
                      : const HomeBody(),
                ),
                if (showLoginPrompt) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () =>
                          context.read<HomeCuibtCubit>().dismissLoginPrompt(),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                  Center(
                    child: _WelcomeLoginCard(
                      onLogin: () {
                        final cubit = context.read<HomeCuibtCubit>();
                        cubit.dismissLoginPrompt();
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(Routes.loginRoute)
                            .then((_) => cubit.checkLoginStatus());
                      },
                      onDismiss: () =>
                          context.read<HomeCuibtCubit>().dismissLoginPrompt(),
                    ),
                  ),
                ],
              ],
            ),

            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: BlocBuilder<CartCubit, CartState>(
              buildWhen: (previous, current) =>
                  previous.totalItemsCount != current.totalItemsCount,
              builder: (context, cartState) {
                final count = cartState.totalItemsCount;
                return (state.bannersError != null &&
                        state.categoriesError != null &&
                        state.productsError != null)
                    ? const SizedBox.shrink()
                    : Stack(
                        clipBehavior: Clip.none,
                        children: [
                          FloatingActionButton(
                            key: CartAnimationHelper.cartKey,
                            heroTag: 'fab_cart',
                            elevation: 8,
                            highlightElevation: 3,
                            clipBehavior: Clip.none,
                            shape: const CircleBorder(),
                            backgroundColor: ColorManger.white.withValues(
                              alpha: 0.7,
                            ),
                            onPressed: () {
                              if (state.isLoggedIn) {
                                Navigator.pushNamed(context, Routes.cartRoute);
                              } else {
                                Navigator.pushNamed(context, Routes.loginRoute);
                              }
                            },
                            child: Transform.translate(
                              offset: Offset(-8.w, 1.h),
                              child: Transform.rotate(
                                angle: -0.09,
                                child: Image.asset(
                                  ImageAsset.cart,
                                  width: 65.w,
                                  height: 65.h,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),
                          ),

                          if (count > 0)
                            PositionedDirectional(
                              top: -4,
                              start: 15,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorManger.chipProtein,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 18.w,
                                  minHeight: 18.h,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
              },
            ),
          );
        },
      ),
    );
  }
}

class _WelcomeLoginCard extends StatelessWidget {
  const _WelcomeLoginCard({required this.onLogin, required this.onDismiss});

  final VoidCallback onLogin;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310.w,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: GestureDetector(
              onTap: onDismiss,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 16, color: Colors.grey.shade500),
              ),
            ),
          ),
          Container(
            width: 1000.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManger.backgroundItem,
                  ColorManger.backgroundItem,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorManger.primaryLight.withValues(alpha: 0.1),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Image.asset(
              ImageAsset.loginFarmer,
              width: 16.w,
              height: 16.h,
              // color: ColorManger.primaryLight,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'سجل حسابك الآن',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              color: ColorManger.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              'سجل دخولك لمتابعة الأسعار، وتتبع شحناتك، والاستمتاع بكافة مزايا التطبيق',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManger.primaryLight,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'تسجيل الدخول الآن',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: onDismiss,
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade800,
              padding: const EdgeInsets.symmetric(vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'تصفح كزائر الآن',
              style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
