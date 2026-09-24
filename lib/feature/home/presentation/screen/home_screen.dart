import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/statsScreen/global_error.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/core/utils/cart_animation_helper.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_state.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/refactor/home_body.dart';
import 'package:aleman/feature/home/presentation/widget/quick_login_card.dart';
import 'package:aleman/feature/notification/logic/notification_cubit.dart';
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
  final GlobalKey _cartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    CartAnimationHelper.cartKey = _cartKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartCubit>().getCartCount();
      }
    });
  }

  @override
  void dispose() {
    if (CartAnimationHelper.cartKey == _cartKey) {
      CartAnimationHelper.cartKey = null;
    }
    super.dispose();
  }

  Future<void> _navigateToLogin() async {
    final result = await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(Routes.loginRoute);
    if (result == true && mounted) {
      context.read<HomeCuibtCubit>().fetchHomeData();
      context.read<CartCubit>().getCartCount();
      context.read<NotificationCubit>().getUnreadCount();
    }
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
                        color: Colors.black.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                  QuickLoginCard(
                    onDismiss: () =>
                        context.read<HomeCuibtCubit>().dismissLoginPrompt(),
                    onLoginSuccess: () {
                      context.read<HomeCuibtCubit>().dismissLoginPrompt();
                      context.read<HomeCuibtCubit>().fetchHomeData();
                      context.read<CartCubit>().getCartCount();
                      context.read<NotificationCubit>().getUnreadCount();
                    },
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
                            key: _cartKey,
                            heroTag: null,
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
                                _navigateToLogin();
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

                          if (count > 0 && state.isLoggedIn)
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
