import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/order/data/model/calculate_shipping_model.dart';
import 'package:aleman/feature/order/data/model/create_order_request.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/model/small_merchants_orders_response.dart';

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
  Future<ApiResult<SmallMerchantsOrdersResponse>> getSmallMerchantsOrders({
    int page = 1,
    int pageSize = 10,
  });
}

class OrderRepositoryImplement implements OrderRepository {
  final AppServiceClient _apiService;

  OrderRepositoryImplement(this._apiService);

  @override
  Future<ApiResult<CalculateShippingResponse>> calculateShipping(
    CalculateShippingRequest request,
  ) async {
    try {
      final result = await _apiService.calculateShipping(request);
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
      final result = await _apiService.createOrder(request);
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<List<OrderResponseModel>>> getMyOrders({int? status}) async {
    try {
      final response = await _apiService.getMyOrders(status);

      List<dynamic> listData = [];
      if (response is List) {
        listData = response;
      } else if (response is Map<String, dynamic>) {
        if (response['orders'] is List) {
          listData = response['orders'] as List<dynamic>;
        } else if (response['data'] is List) {
          listData = response['data'] as List<dynamic>;
        } else if (response['items'] is List) {
          listData = response['items'] as List<dynamic>;
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
      final response = await _apiService.getOrderDetails(orderId);
      Map<String, dynamic> map = {};
      if (response is Map<String, dynamic>) {
        map = response;
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
      await _apiService.cancelOrder(orderId);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<SmallMerchantsOrdersResponse>> getSmallMerchantsOrders({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final result = await _apiService.getSmallMerchantsOrders(page, pageSize);
      return ApiResult.success(result);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
