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
  Future<ApiResult<List<OrderResponseModel>>> getMyOrders();
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
  Future<ApiResult<List<OrderResponseModel>>> getMyOrders() async {
    try {
      final response = await _dio.get(ApiConstants.orders);
      final list = (response.data as List<dynamic>)
          .map((e) => OrderResponseModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
