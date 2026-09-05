import 'package:aleman/core/language/localization_extensions.dart';
import 'package:aleman/core/language/strings_manger.dart';
import 'package:aleman/core/services/app_logout.dart';
import 'package:aleman/core/statsScreen/error_info.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RouteStatesScreen extends StatelessWidget {
  const RouteStatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: AspectRatio(
                aspectRatio: 1,
                child: SvgPicture.asset(
                  ImageAsset.noRoute,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ErrorInfo(
              title: context.translate(AppStrings.youAreNotLoggedIn),
              description: context.translate(
                AppStrings
                    .pleaseLoginToContinueAndEnjoyFullAccessToTheAppFeatures,
              ),
              btnText: context.translate(AppStrings.logIn),
              press: () async {
                await const AppLogout().logOutThenNavigateToLogin(context);
              },
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
