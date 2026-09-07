import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class CartError extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, top: 100.h),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Image.asset(ImageAsset.error, width: 350.w),
          SizedBox(height: 10.h),

          Container(
            height: 10.h,
            width: 10.w,

            decoration: BoxDecoration(
              color: ColorManger.primaryLight,
              borderRadius: BorderRadius.circular(40.r),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 20.h,
            width: 20.w,

            decoration: BoxDecoration(
              color: ColorManger.primaryLight,
              borderRadius: BorderRadius.circular(40.r),
            ),
          ),
          SizedBox(height: 10.h),
          InkWell(
            onTap: () {
              context.read<CartCubit>().getCart();
            },
            child: Container(
              height: 50.h,
              width: 50.w,

              decoration: BoxDecoration(
                color: ColorManger.primaryLight,
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Icon(Iconsax.refresh1, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
