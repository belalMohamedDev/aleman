import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/address/data/repository/address_repo.dart';
import 'package:aleman/feature/address/logic/cubit/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressCubit extends Cubit<AddressState> {
  final UserAddressRepository _repository;

  AddressCubit(this._repository) : super(const AddressState());

  Future<void> loadAddresses() async {
    emit(state.copyWith(status: AddressStatus.loading, errorMessage: null));
    final result = await _repository.getMyAddresses();
    result.when(
      success: (addresses) {
        emit(state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: AddressStatus.error,
          errorMessage: error.message ?? 'فشل في تحميل العناوين',
        ));
      },
    );
  }

  Future<void> deleteAddress(String id) async {
    emit(state.copyWith(isActionLoading: true, errorMessage: null));
    final result = await _repository.deleteAddress(id);
    result.when(
      success: (_) {
        final updated = state.addresses.where((a) => a.id != id).toList();
        emit(state.copyWith(
          isActionLoading: false,
          addresses: updated,
          actionSuccessMessage: 'تم حذف العنوان بنجاح',
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          isActionLoading: false,
          errorMessage: error.message ?? 'تعذر حذف العنوان',
        ));
      },
    );
  }
}
