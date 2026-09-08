import 'package:aleman/feature/address/data/model/user_address_model.dart';

enum AddressStatus { initial, loading, success, error }

class AddressState {
  final AddressStatus status;
  final List<UserAddressModel> addresses;
  final String? errorMessage;
  final bool isActionLoading;
  final String? actionSuccessMessage;

  const AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.errorMessage,
    this.isActionLoading = false,
    this.actionSuccessMessage,
  });

  AddressState copyWith({
    AddressStatus? status,
    List<UserAddressModel>? addresses,
    String? errorMessage,
    bool? isActionLoading,
    String? actionSuccessMessage,
  }) {
    return AddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      errorMessage: errorMessage,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      actionSuccessMessage: actionSuccessMessage,
    );
  }
}
