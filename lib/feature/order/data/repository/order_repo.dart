import 'dart:io';
import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/network/dio_factory/dio_factory.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/core/network/failure/api_error_model.dart';
import 'package:aleman/feature/order/data/model/bank_account_model.dart';
import 'package:aleman/feature/order/data/model/calculate_shipping_model.dart';
import 'package:aleman/feature/order/data/model/create_order_request.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/model/small_merchants_orders_response.dart';
import 'package:dio/dio.dart';

abstract class OrderRepository {
  Future<ApiResult<CalculateShippingResponse>> calculateShipping(
    CalculateShippingRequest request,
  );
  Future<ApiResult<OrderResponseModel>> createOrder(
    CreateOrderRequest request,
  );
  Future<ApiResult<String>> uploadReceipt(File file);
  Future<ApiResult<String>> uploadOrderReceipt({
    required String orderId,
    required File file,
  });
  Future<ApiResult<List<BankAccountModel>>> getBankAccounts();
  Future<ApiResult<List<OrderResponseModel>>> getMyOrders({int? status});
  Future<ApiResult<OrderResponseModel>> getOrderDetails(String orderId);
  Future<ApiResult<void>> cancelOrder(String orderId);
  Future<ApiResult<SmallMerchantsOrdersResponse>> getSmallMerchantsOrders({
    int page = 1,
    int pageSize = 10,
  });
  Future<ApiResult<void>> reviewOrderByMerchant({
    required String orderId,
    required bool isApproved,
    String? rejectionReason,
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

  @override
  Future<ApiResult<String>> uploadReceipt(File file) async {
    try {
      final fileName = file.path.split(RegExp(r'[/\\]')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final dio = DioFactory.getDio();
      final response = await dio.post(
        ApiConstants.uploadReceipt,
        data: formData,
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final receiptUrl = data['receiptUrl'] as String? ?? '';
        if (receiptUrl.isNotEmpty) {
          return ApiResult.success(receiptUrl);
        }
      }
      return ApiResult.failure(
        ApiErrorModel(message: 'فشل في استلام رابط الإيصال من الخادم'),
      );
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<String>> uploadOrderReceipt({
    required String orderId,
    required File file,
  }) async {
    try {
      final fileName = file.path.split(RegExp(r'[/\\]')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        'orderId': orderId,
      });

      final dio = DioFactory.getDio();
      final response = await dio.post(
        '${ApiConstants.orders}/$orderId/upload-receipt',
        data: formData,
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final receiptUrl =
            (data['receiptUrl'] ?? data['paymentReceiptUrl'] ?? data['url'])
                as String? ??
            '';
        if (receiptUrl.isNotEmpty) {
          return ApiResult.success(receiptUrl);
        }
      }
      return ApiResult.success(response.data?.toString() ?? 'uploaded');
    } catch (e) {
      try {
        final fallback = await uploadReceipt(file);
        return fallback;
      } catch (_) {
        return ApiResult.failure(ApiErrorHandler.handle(e));
      }
    }
  }

  @override
  Future<ApiResult<List<BankAccountModel>>> getBankAccounts() async {
    try {
      final dio = DioFactory.getDio();
      final response = await dio.get('${ApiConstants.orders}/bank-accounts');
      List<dynamic> listData = [];
      if (response.data is List) {
        listData = response.data as List;
      } else if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        if (map['data'] is List) {
          listData = map['data'] as List;
        } else if (map['accounts'] is List) {
          listData = map['accounts'] as List;
        }
      }
      final accounts = listData
          .map((e) => BankAccountModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (accounts.isNotEmpty) {
        return ApiResult.success(accounts);
      }
      return ApiResult.success(_getDefaultBankAccounts());
    } catch (e) {
      return ApiResult.success(_getDefaultBankAccounts());
    }
  }

  List<BankAccountModel> _getDefaultBankAccounts() {
    return const [
      BankAccountModel(
        id: 1,
        bankName: 'البنك الأهلي المصري (NBE)',
        accountNumber: '145307098452100018',
        iban: 'EG450002000145307098452100018',
        accountHolderName: 'شركة آل إيمان لتصنيع الأعلاف',
        branchName: 'الفرع الرئيسي',
      ),
      BankAccountModel(
        id: 2,
        bankName: 'بنك مصر (Banque Misr)',
        accountNumber: '38200199401248',
        iban: 'EG120003038200199401248',
        accountHolderName: 'شركة آل إيمان لتصنيع الأعلاف',
        branchName: 'فرع المنطقة الصناعية',
      ),
      BankAccountModel(
        id: 3,
        bankName: 'بنك قطر الوطني (QNB AlAhli)',
        accountNumber: '2031189400215',
        iban: 'EG78001702031189400215',
        accountHolderName: 'شركة آل إيمان لتصنيع الأعلاف',
        branchName: 'فرع مدينة العاشر من رمضان',
      ),
    ];
  }

  @override
  Future<ApiResult<void>> reviewOrderByMerchant({
    required String orderId,
    required bool isApproved,
    String? rejectionReason,
  }) async {
    try {
      final dio = DioFactory.getDio();
      await dio.post(
        '${ApiConstants.orders}/$orderId/merchant-approval',
        data: {
          'isApproved': isApproved,
          'rejectionReason': rejectionReason,
        },
      );
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }
}
