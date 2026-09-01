import 'package:aleman/feature/home/presentation/refactor/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../bottomNavBar/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async { ... });
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
        body: _buildBody(),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTabSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const HomeBody();
      case 1:
        return const Center(
          child: Text(
            "السلة - قريباً",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        );
      case 2:
        return const Center(
          child: Text(
            "المنتجات - قريباً",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        );
      case 3:
        return const Center(
          child: Text(
            "حسابي - قريباً",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        );
      default:
        return const HomeBody();
    }
  }
}
