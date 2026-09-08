import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/address/data/model/create_address_request.dart';
import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:dio/dio.dart';

abstract class UserAddressRepository {
  Future<ApiResult<List<UserAddressModel>>> getMyAddresses();
  Future<ApiResult<UserAddressModel>> addAddress(CreateAddressRequest request);
  Future<ApiResult<void>> deleteAddress(String id);
}

class UserAddressRepositoryImplement implements UserAddressRepository {
  final Dio _dio;

  UserAddressRepositoryImplement(this._dio);

  @override
  Future<ApiResult<List<UserAddressModel>>> getMyAddresses() async {
    try {
      final response = await _dio.get(ApiConstants.userAddresses);
      List<dynamic> listData = [];
      if (response.data is List) {
        listData = response.data as List<dynamic>;
      } else if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        if (map['addresses'] is List) {
          listData = map['addresses'] as List<dynamic>;
        } else if (map['data'] is List) {
          listData = map['data'] as List<dynamic>;
        } else if (map['items'] is List) {
          listData = map['items'] as List<dynamic>;
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
      final response = await _dio.post(
        ApiConstants.userAddresses,
        data: request.toJson(),
      );
      final address =
          UserAddressModel.fromJson(response.data as Map<String, dynamic>);
      return ApiResult.success(address);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> deleteAddress(String id) async {
    try {
      await _dio.delete('${ApiConstants.userAddresses}/$id');
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
