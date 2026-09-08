import 'package:aleman/feature/address/data/model/user_address_model.dart';

enum AddAddressStatus { initial, loading, success, error }

class AddAddressState {
  final AddAddressStatus status;
  final String? selectedGovernorate;
  final String? selectedCity;
  final UserAddressModel? createdAddress;
  final String? errorMessage;
  final String? successMessage;

  const AddAddressState({
    this.status = AddAddressStatus.initial,
    this.selectedGovernorate = 'الشرقية',
    this.selectedCity,
    this.createdAddress,
    this.errorMessage,
    this.successMessage,
  });

  bool get isLoading => status == AddAddressStatus.loading;
  bool get isSuccess => status == AddAddressStatus.success;

  AddAddressState copyWith({
    AddAddressStatus? status,
    String? selectedGovernorate,
    String? selectedCity,
    UserAddressModel? createdAddress,
    String? errorMessage,
    String? successMessage,
    bool clearCity = false,
  }) {
    return AddAddressState(
      status: status ?? this.status,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedCity: clearCity ? null : (selectedCity ?? this.selectedCity),
      createdAddress: createdAddress ?? this.createdAddress,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
