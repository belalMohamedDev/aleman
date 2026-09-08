import 'package:aleman/feature/order/data/model/order_response_model.dart';

class SmallMerchantsOrdersResponse {
  final List<OrderResponseModel> orders;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  const SmallMerchantsOrdersResponse({
    required this.orders,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory SmallMerchantsOrdersResponse.fromJson(Map<String, dynamic> json) {
    final rawOrders = json['orders'] as List<dynamic>? ?? [];
    final ordersList = rawOrders
        .map((e) => OrderResponseModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SmallMerchantsOrdersResponse(
      orders: ordersList,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? ordersList.length,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}
