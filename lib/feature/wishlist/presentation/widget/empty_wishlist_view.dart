import 'package:aleman/core/statsScreen/global_empty_state.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/bottomNavBar/logic/bottom_nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class EmptyWishlistView extends StatelessWidget {
  const EmptyWishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalEmptyState(
      imageAsset: ImageAsset.emptyWhishlist,
      title: 'قائمة المفضلة فارغة',
      description: 'لم تقم بإضافة أي منتجات إلى قائمة رغباتك بعد. تصفح الأصناف وأضف ما يعجبك بضغطة واحدة!',
      buttonText: 'استكشف المنتجات',
      buttonIcon: Iconsax.shop,
      onButtonPressed: () {
        context.read<BottomNavCubit>().changeTab(0);
      },
    );
  }
}
