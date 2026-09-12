import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/vehicle/data/model/create_vehicle_request.dart';
import 'package:aleman/feature/vehicle/data/repository/vehicle_repo.dart';
import 'package:aleman/feature/vehicle/logic/cubit/vehicle_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final UserVehicleRepository _repository;

  VehicleCubit(this._repository) : super(const VehicleState());

  Future<void> loadVehicles() async {
    emit(state.copyWith(status: VehicleStatus.loading, clearError: true));
    final result = await _repository.getMyVehicles();
    result.when(
      success: (vehicles) {
        emit(state.copyWith(status: VehicleStatus.success, vehicles: vehicles));
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: VehicleStatus.error,
            errorMessage:
                error.message ?? 'فشل في تحميل بيانات السائقين والسيارات',
          ),
        );
      },
    );
  }

  Future<bool> addVehicle(CreateVehicleRequest request) async {
    emit(state.copyWith(isActionLoading: true, clearError: true));
    final result = await _repository.addVehicle(request);
    return result.when(
      success: (vehicle) {
        final updatedList = [
          if (request.isDefault)
            ...state.vehicles.map(
              (v) => v.isDefault ? v.copyWithDefault(false) : v,
            ),
          if (!request.isDefault) ...state.vehicles,
          vehicle,
        ];
        emit(
          state.copyWith(
            isActionLoading: false,
            vehicles: updatedList,
            createdOrUpdatedVehicle: vehicle,
            actionSuccessMessage: 'تمت إضافة بيانات السائق والسيارة بنجاح',
          ),
        );
        return true;
      },
      failure: (error) {
        emit(
          state.copyWith(
            isActionLoading: false,
            errorMessage: error.message ?? 'تعذر إضافة بيانات السائق والسيارة',
          ),
        );
        return false;
      },
    );
  }

  Future<bool> updateVehicle(String id, CreateVehicleRequest request) async {
    emit(state.copyWith(isActionLoading: true, clearError: true));
    final result = await _repository.updateVehicle(id, request);
    return result.when(
      success: (vehicle) {
        final updatedList = state.vehicles.map((v) {
          if (v.id == id) return vehicle;
          if (request.isDefault && v.isDefault) return v.copyWithDefault(false);
          return v;
        }).toList();

        emit(
          state.copyWith(
            isActionLoading: false,
            vehicles: updatedList,
            createdOrUpdatedVehicle: vehicle,
            actionSuccessMessage: 'تم تحديث البيانات بنجاح',
          ),
        );
        return true;
      },
      failure: (error) {
        emit(
          state.copyWith(
            isActionLoading: false,
            errorMessage: error.message ?? 'تعذر تحديث البيانات',
          ),
        );
        return false;
      },
    );
  }

  Future<void> deleteVehicle(String id) async {
    emit(state.copyWith(isActionLoading: true, clearError: true));
    final result = await _repository.deleteVehicle(id);
    result.when(
      success: (_) {
        final updated = state.vehicles.where((v) => v.id != id).toList();
        emit(
          state.copyWith(
            isActionLoading: false,
            vehicles: updated,
            actionSuccessMessage: 'تم حذف البيانات بنجاح',
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            isActionLoading: false,
            errorMessage: error.message ?? 'تعذر حذف البيانات',
          ),
        );
      },
    );
  }

  Future<void> setDefaultVehicle(String id) async {
    emit(state.copyWith(isActionLoading: true, clearError: true));
    final result = await _repository.setDefaultVehicle(id);
    result.when(
      success: (_) {
        final updated = state.vehicles.map((v) {
          return v.copyWithDefault(v.id == id);
        }).toList();
        emit(
          state.copyWith(
            isActionLoading: false,
            vehicles: updated,
            actionSuccessMessage: 'تم تعيين السائق/السيارة كافتراضي',
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            isActionLoading: false,
            errorMessage: error.message ?? 'تعذر تعيين السائق الافتراضي',
          ),
        );
      },
    );
  }
}
