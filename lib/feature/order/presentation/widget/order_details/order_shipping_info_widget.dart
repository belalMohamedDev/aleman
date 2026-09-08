/*
import 'package:elminiawy/core/common/shared/shared_imports.dart';

class OrderShippingInfoWidget extends StatelessWidget {
  final OrderResponseData? orderResponse;
  final GetOrdersResponseData? order;

  const OrderShippingInfoWidget({super.key, this.orderResponse, this.order});

  @override
  Widget build(BuildContext context) {
    final bool isEnLocale = AppLocalizations.of(context)?.isEnLocale ?? true;
    final dynamic response = order ?? orderResponse;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManger.backgroundItem,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 12.w,
          right: 18.w,
          top: 12.h,
          bottom: 15.h,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 5.w),
                Text(
                  "${context.translate(AppStrings.totalPrice)}  ${response.totalOrderPrice ?? ''}  ${context.translate(AppStrings.egy)}",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontSize: 12.sp),
                ),
                SizedBox(width: 30.w),
                const Spacer(),
                Container(
                  height: 40.h,
                  width: 1.w,
                  decoration: BoxDecoration(color: ColorManger.brownLight),
                ),
                const Spacer(),
                Icon(Icons.credit_card, color: ColorManger.brun),
                SizedBox(width: 20.w),
                Text(
                  response.paymentMethodType == 'cash'
                      ? isEnLocale
                            ? "${response.paymentMethodType ?? ""}"
                            : 'كاش عند الاستلام'
                      : isEnLocale
                      ? "${response.paymentMethodType ?? ""}"
                      : 'بطاقة ائتمانية',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontSize: 12.sp),
                ),
                const Spacer(),
              ],
            ),
            Divider(color: ColorManger.brownLight),
            SizedBox(height: response.shippingAddress != null ? 10.h : 0),
            response.shippingAddress != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(IconlyBold.location, color: ColorManger.brun),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          "${response.shippingAddress?.phone ?? ''},   ${response.shippingAddress?.region ?? ''}",
                          softWrap: true,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(fontSize: 12.sp),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            SizedBox(height: 5.h),
            response.shippingAddress != null
                ? Divider(color: ColorManger.brownLight)
                : const SizedBox(),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.translate(AppStrings.shippingPrice),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontSize: 12.sp),
                ),
                const Spacer(),
                Text(
                  "${response.shippingPrice ?? ''}  ${context.translate(AppStrings.egy)}",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.translate(AppStrings.taxPrice),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontSize: 12.sp),
                ),
                const Spacer(),
                Text(
                  "${response.taxPrice ?? ""}  ${context.translate(AppStrings.egy)}",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

*/
