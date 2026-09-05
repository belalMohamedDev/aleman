import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:aleman/feature/home/presentation/refactor/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    context.read<HomeCuibtCubit>().fetchHomeData();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await SharedPrefHelper.getSecuredString(
        PrefKeys.userAccessToken);
    if (mounted) {
      setState(() {
        _isLoggedIn = token.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        // Important: this allows the body to flow underneath the transparent/floating nav bar
        extendBody: true,
        body: RefreshIndicator(
          color: ColorManger.primary,
          backgroundColor: ColorManger.white,
          onRefresh: () async {
            await context.read<HomeCuibtCubit>().fetchHomeData();
          },
          child: const HomeBody(),
        ),
        // bottomNavigationBar: CustomBottomNavBar(
        //   currentIndex: _currentIndex,
        //   onTabSelected: (index) {
        //     setState(() {
        //       _currentIndex = index;
        //     });
        //   },
        // ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,

        floatingActionButton: _isLoggedIn
            ? FloatingActionButton(
                // shape: const CircleBorder(),
                onPressed: () {},
                backgroundColor:
                    ColorManger.primaryLight.withValues(alpha: 0.9),
                child: const Icon(Iconsax.bag_happy4, color: Colors.white),
              )
            : null,
      ),
    );
  }

  // Widget _buildBody() {
  //   switch (_currentIndex) {
  //     case 0:
  //       return const HomeBody();
  //     case 1:
  //       return const Center(
  //         child: Text(
  //           "السلة - قريباً",
  //           style: TextStyle(color: Colors.white, fontSize: 24),
  //         ),
  //       );
  //     case 2:
  //       return const Center(
  //         child: Text(
  //           "المنتجات - قريباً",
  //           style: TextStyle(color: Colors.white, fontSize: 24),
  //         ),
  //       );
  //     case 3:
  //       return const Center(
  //         child: Text(
  //           "حسابي - قريباً",
  //           style: TextStyle(color: Colors.white, fontSize: 24),
  //         ),
  //       );
  //     default:
  //       return const HomeBody();
  //   }
  // }
}
