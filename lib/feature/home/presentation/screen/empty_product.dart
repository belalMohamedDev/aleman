import 'package:aleman/core/statsScreen/global_empty_state.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/bottomNavBar/logic/bottom_nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class EmptyCategoryProduct extends StatelessWidget {
  const EmptyCategoryProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: GlobalEmptyState(
        imageAsset: ImageAsset.noProduct,
        title: 'قائمة المنتجات فارغة',
        description: 'لم يتم إضافة أي منتجات إلى هذا القسم بعد. تصفح الأصناف واستكشف أفضل أنواع الأعلاف بضغطة واحدة!',
        buttonText: 'استكشف المنتجات',
        buttonIcon: Iconsax.shop,
        onButtonPressed: () {
          Navigator.of(context).maybePop();
          context.read<BottomNavCubit>().changeTab(0);
        },
      ),
    );
  }
}
