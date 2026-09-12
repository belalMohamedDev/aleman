import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/vehicle/data/model/create_vehicle_request.dart';
import 'package:aleman/feature/vehicle/data/model/user_vehicle_model.dart';

abstract class UserVehicleRepository {
  Future<ApiResult<List<UserVehicleModel>>> getMyVehicles();
  Future<ApiResult<UserVehicleModel>> addVehicle(CreateVehicleRequest request);
  Future<ApiResult<UserVehicleModel>> updateVehicle(
    String id,
    CreateVehicleRequest request,
  );
  Future<ApiResult<void>> deleteVehicle(String id);
  Future<ApiResult<void>> setDefaultVehicle(String id);
}

class UserVehicleRepositoryImplement implements UserVehicleRepository {
  final AppServiceClient _apiService;

  UserVehicleRepositoryImplement(this._apiService);

  @override
  Future<ApiResult<List<UserVehicleModel>>> getMyVehicles() async {
    try {
      final response = await _apiService.getVehicles();
      List<dynamic> listData = [];
      if (response is List) {
        listData = response;
      } else if (response is Map<String, dynamic>) {
        if (response['vehicles'] is List) {
          listData = response['vehicles'] as List<dynamic>;
        } else if (response['data'] is List) {
          listData = response['data'] as List<dynamic>;
        } else if (response['items'] is List) {
          listData = response['items'] as List<dynamic>;
        }
      }
      final list = listData
          .map((e) => UserVehicleModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<UserVehicleModel>> addVehicle(
    CreateVehicleRequest request,
  ) async {
    try {
      final vehicle = await _apiService.createVehicle(request);
      return ApiResult.success(vehicle);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<UserVehicleModel>> updateVehicle(
    String id,
    CreateVehicleRequest request,
  ) async {
    try {
      final vehicle = await _apiService.updateVehicle(id, request);
      return ApiResult.success(vehicle);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> deleteVehicle(String id) async {
    try {
      await _apiService.deleteVehicle(id);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> setDefaultVehicle(String id) async {
    try {
      await _apiService.setDefaultVehicle(id);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
