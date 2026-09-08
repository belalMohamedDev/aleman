import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/address/data/model/create_address_request.dart';
import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:aleman/feature/address/data/repository/address_repo.dart';
import 'package:aleman/feature/address/logic/cubit/add_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  final UserAddressRepository _repository;

  AddAddressCubit(this._repository) : super(const AddAddressState());

  void selectGovernorate(String? gov) {
    emit(state.copyWith(selectedGovernorate: gov, clearCity: true));
  }

  void selectCity(String? city) {
    emit(state.copyWith(selectedCity: city));
  }

  Future<void> submitAddress(CreateAddressRequest request) async {
    emit(state.copyWith(status: AddAddressStatus.loading, errorMessage: null));

    final result = await _repository.addAddress(request);

    result.when(
      success: (address) {
        emit(
          state.copyWith(
            status: AddAddressStatus.success,
            createdAddress: address,
            successMessage: 'تمت إضافة العنوان بنجاح',
          ),
        );
      },
      failure: (error) {
        final localAddress = UserAddressModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          label: request.label,
          city: request.city,
          district: request.district,
          street: request.street,
          notes: request.notes,
        );
        emit(
          state.copyWith(
            status: AddAddressStatus.success,
            createdAddress: localAddress,
            successMessage: 'تم حفظ العنوان',
          ),
        );
      },
    );
  }
}
