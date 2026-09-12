import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlay({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Stack(
      children: [
        if (isLoading) ...[
          Opacity(
            opacity: 0.2,
            child: Container(
              color: ColorManger.black,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: Container(
              height: responsive.setHeight(10),
              width: responsive.setWidth(22),
              decoration: BoxDecoration(
                color: ColorManger.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorManger.white,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
