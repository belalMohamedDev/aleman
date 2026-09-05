import 'package:aleman/core/routing/routes.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/refactor/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          final isLoggedIn = state.isLoggedIn;
          final showLoginPrompt = state.showLoginPrompt;

          return Scaffold(
            // Important: this allows the body to flow underneath the transparent/floating nav bar
            extendBody: true,
            body: Stack(
              children: [
                RefreshIndicator(
                  color: ColorManger.primary,
                  backgroundColor: ColorManger.white,
                  onRefresh: () async {
                    await context.read<HomeCuibtCubit>().fetchHomeData();
                  },
                  child: const HomeBody(),
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniStartFloat,
            floatingActionButton: isLoggedIn
                ? FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: ColorManger.primaryLight.withValues(
                      alpha: 0.9,
                    ),
                    child: const Icon(Iconsax.bag_happy4, color: Colors.white),
                  )
                : null,
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
            width: 72.w,
            height: 72.w,
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
              ImageAsset.farmer,
              width: 10.w,
              height: 10.h,
              color: ColorManger.primaryLight,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.login_1, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'تسجيل الدخول الآن',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: onDismiss,
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade500,
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
