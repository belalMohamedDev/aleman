/*
import 'package:elminiawy/core/common/shared/shared_imports.dart';

class CurrentLocationButton extends StatelessWidget {
  const CurrentLocationButton({super.key, required this.mapCubit});
  final MapCubit mapCubit;

  @override
  Widget build(BuildContext context) {
    // Initialize the ResponsiveUtils to handle responsive layout adjustments
    final responsive = ResponsiveUtils(context);

    return Positioned(
      bottom: 165.h,
      right: 25.w,
      child: InkWell(
        onTap: () async {
          await mapCubit.getCurrentLocation(context);

          // Check if widget is still mounted before using context
          if (context.mounted) {
            mapCubit.checkAddressAvailableFetch(mapCubit.targetPosition);
          }
        },
        child: CircleAvatar(
          maxRadius: responsive.setBorderRadius(6),
          backgroundColor: ColorManger.brown,
          child: Image.asset(
            ImageAsset.navigation,
            height: responsive.setHeight(3),
          ),
        ),
      ),
    );
  }
}

*/
