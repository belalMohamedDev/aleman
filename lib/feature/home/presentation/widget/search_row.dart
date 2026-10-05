import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/widget/product_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class SearchRow extends StatelessWidget {
  const SearchRow({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final cubit = context.read<HomeCuibtCubit>();
        final cartCubit = context.read<CartCubit>();
        showSearch(
          context: context,
          delegate: ProductSearchDelegate(
            products: cubit.state.products,
            cartCubit: cartCubit,
            homeCubit: cubit,
          ),
        );
      },
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        height: 46.h,
        padding: EdgeInsets.only(right: 15.w, left: 6.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F8),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.0),
        ),
        child: Row(
          children: [
            Icon(
              Iconsax.search_normal_1,
              size: 20.sp,
              color: ColorManger.primaryLight,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                context.translate(AppStrings.findYourProducts),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: ColorManger.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Iconsax.setting_4,
                size: 18.sp,
                color: ColorManger.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
