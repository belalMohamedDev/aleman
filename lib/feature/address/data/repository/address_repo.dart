import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/address/data/model/create_address_request.dart';
import 'package:aleman/feature/address/data/model/user_address_model.dart';

abstract class UserAddressRepository {
  Future<ApiResult<List<UserAddressModel>>> getMyAddresses();
  Future<ApiResult<UserAddressModel>> addAddress(CreateAddressRequest request);
  Future<ApiResult<void>> deleteAddress(String id);
}

class UserAddressRepositoryImplement implements UserAddressRepository {
  final AppServiceClient _apiService;

  UserAddressRepositoryImplement(this._apiService);

  @override
  Future<ApiResult<List<UserAddressModel>>> getMyAddresses() async {
    try {
      final response = await _apiService.getAddresses();
      List<dynamic> listData = [];
      if (response is List) {
        listData = response;
      } else if (response is Map<String, dynamic>) {
        if (response['addresses'] is List) {
          listData = response['addresses'] as List<dynamic>;
        } else if (response['data'] is List) {
          listData = response['data'] as List<dynamic>;
        } else if (response['items'] is List) {
          listData = response['items'] as List<dynamic>;
        }
      }
      final list = listData
          .map((e) => UserAddressModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<UserAddressModel>> addAddress(CreateAddressRequest request) async {
    try {
      final address = await _apiService.createAddress(request);
      return ApiResult.success(address);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> deleteAddress(String id) async {
    try {
      await _apiService.deleteAddress(id);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
