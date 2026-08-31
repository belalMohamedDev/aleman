import 'package:aleman/feature/home/presentation/refactor/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   if (!mounted) return;
    //   context.read<LogOutCubit>().getUserName();

    //   if (!AppInitialRoute.isAnonymousUser) {
    //     _notificationService.fetchNotificationsContinuously();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),

      child: Scaffold(body: HomeBody()),
    );
  }
}
