import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.setWidth(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImageAsset.noInternet,
                  width: responsive.setWidth(80),
                  height: responsive.setHeight(40),
                  fit: BoxFit.contain,
                ),
                SizedBox(height: responsive.setHeight(4)),
                Text(
                  'لا يوجد اتصال بالإنترنت',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primaryLight,
                  ),
                ),
                SizedBox(height: responsive.setHeight(2)),
                Text(
                  'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                SizedBox(height: responsive.setHeight(6)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
