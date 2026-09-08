import 'package:aleman/feature/profile/data/model/user_profile_model.dart';
import 'package:aleman/feature/profile/logic/cubit/small_merchants_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmallMerchantsCubit extends Cubit<SmallMerchantsState> {
  SmallMerchantsCubit(List<SmallMerchantModel> initialMerchants)
      : super(SmallMerchantsState(allMerchants: initialMerchants));

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
  }
}
