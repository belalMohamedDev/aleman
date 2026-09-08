/*
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:elminiawy/core/common/shared/shared_imports.dart';

class OrderProductListWidget extends StatelessWidget {
  final OrderResponseData? orderResponse;
  final GetOrdersResponseData? order;

  const OrderProductListWidget({super.key, this.orderResponse, this.order});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final cartItems = order?.cartItems ?? orderResponse?.cartItems;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: cartItems == null ? 0 : cartItems.length,
        (context, index) {
          return Padding(
            padding: responsive.setPadding(bottom: 1),
            child: Slidable(
              child: Container(
                width: double.infinity,
                height: responsive.setHeight(10),
                decoration: BoxDecoration(
                  color: ColorManger.backgroundItem,
                  borderRadius: BorderRadius.circular(
                    responsive.setBorderRadius(3),
                  ),
                ),
                child: Row(
                  children: [
                    responsive.setSizeBox(width: 3),
                    Container(
                      width: responsive.setWidth(20),
                      decoration: BoxDecoration(
                        color: ColorManger.brownLight,
                        borderRadius: BorderRadius.circular(
                          responsive.setBorderRadius(3),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            order?.cartItems?[index].product?.image ??
                            orderResponse?.cartItems?[index].product?.image ??
                            '',
                        height: responsive.setHeight(8),
                        placeholder: (context, url) => Image.asset(
                          ImageAsset.picture,
                          height: responsive.setHeight(8),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    responsive.setSizeBox(width: 2),
                    Expanded(
                      child: _namePriceAndRatingColumn(
                        order,
                        index,
                        orderResponse,
                        context,
                        responsive,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Column _namePriceAndRatingColumn(
    GetOrdersResponseData? order,
    int index,
    OrderResponseData? orderResponse,
    BuildContext context,
    ResponsiveUtils responsive,
  ) {
    final dynamic response = order ?? orderResponse;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          response!.cartItems![index].product!.title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontSize: responsive.setTextSize(3)),
        ),
        responsive.setSizeBox(height: 1),
        IgnorePointer(
          ignoring: true,
          child: RatingBar(
            initialRating: response.cartItems![index].product!.ratingsAverage,
            direction: Axis.horizontal,
            itemSize: responsive.setIconSize(4),
            itemCount: 5,
            allowHalfRating: true,
            itemPadding: responsive.setPadding(left: 0.2, right: 0.2),
            onRatingUpdate: (rating) {},
            ratingWidget: RatingWidget(
              full: Icon(IconlyBold.star, color: ColorManger.brown),
              half: Icon(IconlyBold.star, color: ColorManger.brun),
              empty: Icon(IconlyBroken.star, color: ColorManger.brunLight),
            ),
          ),
        ),
        responsive.setSizeBox(height: 1),
        Text(
          '${context.translate(AppStrings.totalPrice)}   ${response.cartItems![index].totalItemPrice}  ${context.translate(AppStrings.egy)} ',
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontSize: responsive.setTextSize(3)),
        ),
      ],
    );
  }
}

*/
