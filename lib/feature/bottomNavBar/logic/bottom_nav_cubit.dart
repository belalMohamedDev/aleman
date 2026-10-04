import 'package:flutter_bloc/flutter_bloc.dart';

enum BottomNavTab {
  home,
  orders,
  wishlist,
  profile,
}

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  void changeTab(int newIndex) {
    if (state != newIndex) {
      emit(newIndex);
    }
  }

  void goToHome() => changeTab(0);
  void goToOrders() => changeTab(1);
  void goToWishlist() => changeTab(2);
  void goToCart() => changeTab(2);
  void goToProfile() => changeTab(3);
}
