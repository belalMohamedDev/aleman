import 'package:aleman/core/statsScreen/global_error.dart';
import 'package:aleman/core/style/images/asset_manger.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GlobalError(
          imageAsset: ImageAsset.noInternet,
          title: 'لا يوجد اتصال بالإنترنت',
          message: 'يرجى التحقق من اتصالك بالشبكة والمحاولة مرة أخرى للوصول إلى كافة خدمات التطبيق.',
          // retryText: 'إعادة المحاولة',
          // onRetry: () {
          //   context.read<NetworkCubit>().checkConnection();
          // },
        ),
      ),
    );
  }
}
