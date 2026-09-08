import 'package:aleman/feature/order/data/model/order_response_model.dart';

enum OrdersStatus { initial, loading, success, error }

class OrdersState {
  final OrdersStatus status;
  final List<OrderResponseModel> orders;
  final String? errorMessage;
  final int selectedTab; // 0: الطلبات الحالية, 1: الطلبات السابقة
  final bool isCancelling;
  final String? actionMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.errorMessage,
    this.selectedTab = 0,
    this.isCancelling = false,
    this.actionMessage,
  });

  int get activeOrdersCount => orders.where((o) => o.isActive).length;
  int get completedOrdersCount => orders.where((o) => o.isCompleted).length;
  int get cancelledOrdersCount => orders.where((o) => o.isCancelled).length;

  List<OrderResponseModel> get filteredOrders {
    if (selectedTab == 0) {
      return orders.where((o) => o.isActive).toList();
    } else {
      return orders.where((o) => o.isCompleted || o.isCancelled).toList();
    }
  }

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderResponseModel>? orders,
    String? errorMessage,
    int? selectedTab,
    bool? isCancelling,
    String? actionMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage,
      selectedTab: selectedTab ?? this.selectedTab,
      isCancelling: isCancelling ?? this.isCancelling,
      actionMessage: actionMessage,
    );
  }
}
