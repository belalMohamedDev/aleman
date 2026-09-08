/*
import 'package:elminiawy/core/common/shared/shared_imports.dart';

class DriverInformationWidget extends StatelessWidget {
  final GetOrdersResponseData? order;

  const DriverInformationWidget({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    return Container(
      width: double.infinity,
      height: responsive.setHeight(10),
      decoration: BoxDecoration(
        color: ColorManger.backgroundItem,
        borderRadius: BorderRadius.circular(responsive.setBorderRadius(2.5)),
      ),
      child: Padding(
        padding: responsive.setPadding(left: 3, right: 3, top: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  ImageAsset.deliveryBike,
                  height: responsive.setHeight(2.4),
                ),
                responsive.setSizeBox(width: 2),
                Text(
                  context.translate(AppStrings.driverData),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: responsive.setTextSize(4),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.setHeight(1.5)),
            Row(
              children: [
                Icon(
                  IconlyBold.profile,
                  color: ColorManger.brun,
                  size: responsive.setHeight(2),
                ),
                responsive.setSizeBox(width: 2),
                Text(
                  '${order?.driverId?.name}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: ColorManger.brun,
                    fontSize: responsive.setTextSize(3.5),
                  ),
                ),
                responsive.setSizeBox(width: 10),
                Icon(
                  IconlyBold.call,
                  color: ColorManger.brun,
                  size: responsive.setHeight(2),
                ),
                responsive.setSizeBox(width: 2),
                Text(
                  '${order?.driverId?.phone}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: ColorManger.brun,
                    fontSize: responsive.setTextSize(3.5),
                  ),
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
