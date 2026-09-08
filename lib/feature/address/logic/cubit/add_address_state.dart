import 'package:aleman/feature/address/data/model/user_address_model.dart';

enum AddAddressStatus { initial, loading, success, error }

class AddAddressState {
  final AddAddressStatus status;
  final UserAddressModel? createdAddress;
  final String? errorMessage;
  final String? successMessage;

  const AddAddressState({
    this.status = AddAddressStatus.initial,
    this.createdAddress,
    this.errorMessage,
    this.successMessage,
  });

  bool get isLoading => status == AddAddressStatus.loading;
  bool get isSuccess => status == AddAddressStatus.success;

  AddAddressState copyWith({
    AddAddressStatus? status,
    UserAddressModel? createdAddress,
    String? errorMessage,
    String? successMessage,
  }) {
    return AddAddressState(
      status: status ?? this.status,
      createdAddress: createdAddress ?? this.createdAddress,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
