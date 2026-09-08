/*
import 'package:elminiawy/core/common/shared/shared_imports.dart';

class OrderIdWidget extends StatelessWidget {
  final OrderResponseData? orderResponse;
  final GetOrdersResponseData? order;

  const OrderIdWidget({super.key, this.orderResponse, this.order});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final dynamic response = order ?? orderResponse;
    final int orderStatus = response!.status!;

    return Container(
      height: responsive.setHeight(8),
      decoration: BoxDecoration(
        color: ColorManger.brownLight,
        borderRadius: BorderRadius.circular(responsive.setBorderRadius(3)),
      ),
      child: Row(
        children: [
          responsive.setSizeBox(width: 4),
          Image.asset(
            orderStatus == 5
                ? ImageAsset.orderCancel
                : orderStatus == 4
                ? ImageAsset.orderDelivered
                : ImageAsset.shoppingBag,
            height: responsive.setHeight(5),
          ),
          responsive.setSizeBox(width: 4),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.translate(AppStrings.orderID),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: responsive.setTextSize(3.5),
                ),
              ),
              responsive.setSizeBox(height: 0.5),
              Text(
                "# ${response!.sId ?? ''}",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: responsive.setTextSize(3.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

*/
