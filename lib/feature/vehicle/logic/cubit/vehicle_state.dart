import 'package:aleman/feature/vehicle/data/model/user_vehicle_model.dart';

enum VehicleStatus { initial, loading, success, error }

class VehicleState {
  final VehicleStatus status;
  final List<UserVehicleModel> vehicles;
  final bool isActionLoading;
  final String? errorMessage;
  final String? actionSuccessMessage;
  final UserVehicleModel? createdOrUpdatedVehicle;

  const VehicleState({
    this.status = VehicleStatus.initial,
    this.vehicles = const [],
    this.isActionLoading = false,
    this.errorMessage,
    this.actionSuccessMessage,
    this.createdOrUpdatedVehicle,
  });

  VehicleState copyWith({
    VehicleStatus? status,
    List<UserVehicleModel>? vehicles,
    bool? isActionLoading,
    String? errorMessage,
    String? actionSuccessMessage,
    UserVehicleModel? createdOrUpdatedVehicle,
    bool clearActionSuccess = false,
    bool clearError = false,
  }) {
    return VehicleState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionSuccessMessage: clearActionSuccess
          ? null
          : (actionSuccessMessage ?? this.actionSuccessMessage),
      createdOrUpdatedVehicle:
          createdOrUpdatedVehicle ?? this.createdOrUpdatedVehicle,
    );
  }
}
