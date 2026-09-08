/*
import 'package:elminiawy/core/common/shared/shared_imports.dart';

class OrderStepperWidget extends StatelessWidget {
  final OrderResponseData? orderResponse;
  final GetOrdersResponseData? order;

  const OrderStepperWidget({super.key, this.orderResponse, this.order});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final bool isEnLocale = AppLocalizations.of(context)?.isEnLocale ?? true;
    final dynamic response = order ?? orderResponse;

    final int orderStatus = response!.status;
    final String createAt = response.createdAt;
    final String updatedAt = response.updatedAt;
    final String paitAt = response.driverDeliveredAt ?? updatedAt;
    final String adminAcceptedAt = response.adminAcceptedAt ?? updatedAt;
    final String adminCompletedAt = response.adminCompletedAt ?? updatedAt;
    final String driverAcceptedAt = response.driverAcceptedAt ?? updatedAt;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManger.backgroundItem,
        borderRadius: BorderRadius.circular(responsive.setBorderRadius(3)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 15.h,
          right: 20.w,
          left: 20.w,
          bottom: 20.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.translate(AppStrings.orderStatus),
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 15.h),
            orderStatus != 5
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStep(
                        context: context,
                        isCompleted: orderStatus >= 0,
                        title: context.translate(AppStrings.orderPlaced),
                        isEnLocale: isEnLocale,
                        subTitle: '${createAt.getFormattedDateAndHourse()} .',
                      ),
                      _buildLine(orderStatus > 0, isEnLocale),
                      _buildStep(
                        context: context,
                        isCompleted: orderStatus >= 1,
                        title: context.translate(AppStrings.preparing),
                        subTitle:
                            '${adminAcceptedAt.getFormattedDateAndHourse()} .',
                        isEnLocale: isEnLocale,
                      ),
                      _buildLine(orderStatus > 1, isEnLocale),
                      _buildStep(
                        context: context,
                        isCompleted: orderStatus >= 2,
                        title: context.translate(
                          AppStrings.theOrderAcceptedByRestaurant,
                        ),
                        isEnLocale: isEnLocale,
                        subTitle:
                            '${adminCompletedAt.getFormattedDateAndHourse()} .',
                      ),
                      _buildLine(orderStatus > 2, isEnLocale),
                      _buildStep(
                        context: context,
                        isCompleted: orderStatus >= 3,
                        isEnLocale: isEnLocale,
                        title: context.translate(AppStrings.onItsWay),
                        subTitle:
                            '${driverAcceptedAt.getFormattedDateAndHourse()} .',
                      ),
                      _buildLine(orderStatus > 3, isEnLocale),
                      _buildStep(
                        context: context,
                        isCompleted: orderStatus >= 4,
                        isEnLocale: isEnLocale,
                        title: context.translate(AppStrings.delivered),
                        subTitle: '${paitAt.getFormattedDateAndHourse()} .',
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStep(
                        context: context,
                        isCompleted: orderStatus == 5,
                        title: context.translate(AppStrings.orderPlaced),
                        isEnLocale: isEnLocale,
                        subTitle: '${createAt.getFormattedDateAndHourse()} .',
                      ),
                      _buildLine(orderStatus == 5, isEnLocale),
                      _buildStep(
                        isCancelled: true,
                        context: context,
                        isCompleted: orderStatus == 5,
                        title: context.translate(AppStrings.cancelled),
                        subTitle: context.translate(
                          AppStrings.yourOrderWasCancelled,
                        ),
                        imagePath: ImageAsset.orderCancel,
                        isEnLocale: isEnLocale,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Padding _buildLine(bool isCompleted, bool isEnLocale) {
    return Padding(
      padding: EdgeInsets.only(
        left: isEnLocale ? 10.w : 0,
        right: isEnLocale ? 0 : 10,
      ),
      child: Column(
        children: List.generate(
          2,
          (index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Container(
              width: isCompleted ? 1.6.w : 1.8.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: isCompleted ? ColorManger.brun : ColorManger.brownLight,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _buildStep({
    required BuildContext context,
    required bool isCompleted,
    required bool isEnLocale,
    bool isCancelled = false,
    required String title,
    required String subTitle,
    String imagePath = ImageAsset.orderDelivered,
  }) {
    return Row(
      children: [
        SizedBox(width: isCompleted ? 0 : 5.5.w),
        CircleAvatar(
          radius: isCompleted ? 11.r : 5.r,
          backgroundColor: isCancelled
              ? ColorManger.backgroundItem
              : ColorManger.brownLight,
          child: isCompleted ? Image.asset(imagePath) : null,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: isEnLocale ? 20.w : 0,
            right: isEnLocale ? 0 : 20.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: isCompleted ? ColorManger.brun : ColorManger.brunLight,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: isCompleted ? 5.h : 0),
              isCompleted
                  ? Text(
                      subTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(fontSize: 10.sp),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}

*/
