import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/order/data/model/calculate_shipping_model.dart';
import 'package:aleman/feature/order/data/model/create_order_request.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:dio/dio.dart';

abstract class OrderRepository {
  Future<ApiResult<CalculateShippingResponse>> calculateShipping(
    CalculateShippingRequest request,
  );
  Future<ApiResult<OrderResponseModel>> createOrder(
    CreateOrderRequest request,
  );
  Future<ApiResult<List<OrderResponseModel>>> getMyOrders({int? status});
  Future<ApiResult<OrderResponseModel>> getOrderDetails(String orderId);
  Future<ApiResult<void>> cancelOrder(String orderId);
}

class OrderRepositoryImplement implements OrderRepository {
  final Dio _dio;

  OrderRepositoryImplement(this._dio);

  @override
  Future<ApiResult<CalculateShippingResponse>> calculateShipping(
    CalculateShippingRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.calculateShipping,
        data: request.toJson(),
      );
      final result = CalculateShippingResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<OrderResponseModel>> createOrder(
    CreateOrderRequest request,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.orders,
        data: request.toJson(),
      );
      final result = OrderResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<List<OrderResponseModel>>> getMyOrders({int? status}) async {
    try {
      final response = await _dio.get(
        ApiConstants.orders,
        queryParameters: status != null ? {'status': status} : null,
      );

      List<dynamic> listData = [];
      if (response.data is List) {
        listData = response.data as List<dynamic>;
      } else if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        if (map['orders'] is List) {
          listData = map['orders'] as List<dynamic>;
        } else if (map['data'] is List) {
          listData = map['data'] as List<dynamic>;
        } else if (map['items'] is List) {
          listData = map['items'] as List<dynamic>;
        }
      }

      final list = listData
          .map((e) => OrderResponseModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<OrderResponseModel>> getOrderDetails(String orderId) async {
    try {
      final response = await _dio.get('${ApiConstants.orders}/$orderId');
      Map<String, dynamic> map = {};
      if (response.data is Map<String, dynamic>) {
        map = response.data as Map<String, dynamic>;
        if (map.containsKey('order') && map['order'] is Map<String, dynamic>) {
          map = map['order'] as Map<String, dynamic>;
        } else if (map.containsKey('data') && map['data'] is Map<String, dynamic>) {
          map = map['data'] as Map<String, dynamic>;
        }
      }
      final result = OrderResponseModel.fromJson(map);
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> cancelOrder(String orderId) async {
    try {
      await _dio.post('${ApiConstants.orders}/$orderId/cancel');
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
