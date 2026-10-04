import 'package:aleman/core/statsScreen/global_empty_state.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/bottomNavBar/logic/bottom_nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 100.h),
      child: GlobalEmptyState(
        imageAsset: ImageAsset.emptyCart,
        title: 'سلة المشتريات فارغة',
        description: 'أضف منتجاتك المفضلة إلى السلة لتظهر هنا، ثم راجع اختياراتك وأكمل طلبك بكل سهولة.',
        buttonText: 'استكشف المنتجات',

        onButtonPressed: () {
          Navigator.of(context).maybePop();
          context.read<BottomNavCubit>().changeTab(0);
        },
      ),
    );
  }
}
