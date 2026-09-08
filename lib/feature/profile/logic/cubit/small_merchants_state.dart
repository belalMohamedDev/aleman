import 'package:aleman/feature/profile/data/model/user_profile_model.dart';

class SmallMerchantsState {
  final List<SmallMerchantModel> allMerchants;
  final String searchQuery;

  const SmallMerchantsState({
    this.allMerchants = const [],
    this.searchQuery = '',
  });

  List<SmallMerchantModel> get filteredMerchants {
    if (searchQuery.trim().isEmpty) return allMerchants;
    final query = searchQuery.trim().toLowerCase();
    return allMerchants.where((m) {
      final nameMatch = m.name.toLowerCase().contains(query);
      final phoneMatch = m.phoneNumber.toLowerCase().contains(query);
      final emailMatch = m.email.toLowerCase().contains(query);
      return nameMatch || phoneMatch || emailMatch;
    }).toList();
  }

  SmallMerchantsState copyWith({
    List<SmallMerchantModel>? allMerchants,
    String? searchQuery,
  }) {
    return SmallMerchantsState(
      allMerchants: allMerchants ?? this.allMerchants,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
