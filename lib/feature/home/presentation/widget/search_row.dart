import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/widget/product_search_delegate.dart';
import 'package:aleman/feature/voice_assistant/presentation/widget/ai_voice_assistant_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class SearchRow extends StatelessWidget {
  const SearchRow({super.key});

  void _openSearch(BuildContext context) {
    final cubit = context.read<HomeCuibtCubit>();
    final cartCubit = context.read<CartCubit>();
    showSearch(
      context: context,
      delegate: ProductSearchDelegate(
        products: cubit.state.products,
        cartCubit: cartCubit,
        homeCubit: cubit,
      ),
      query: '',
    );
  }

  void _openVoiceAssistant(BuildContext context) {
    HapticFeedback.mediumImpact();
    AiVoiceAssistantSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _openSearch(context),
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              height: 40.h,
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
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        _VoiceAssistantButton(onTap: () => _openVoiceAssistant(context)),
      ],
    );
  }
}

class _VoiceAssistantButton extends StatelessWidget {
  final VoidCallback onTap;

  const _VoiceAssistantButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorManger.backgroundItem,
      borderRadius: BorderRadius.circular(12.r),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 42.h,
          width: 42.w,
          alignment: Alignment.center,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.02),
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(
              Iconsax.microphone_2,
              size: 20.sp,
              color: ColorManger.primary,
            ),
          ),
        ),
      ),
    );
  }
}
