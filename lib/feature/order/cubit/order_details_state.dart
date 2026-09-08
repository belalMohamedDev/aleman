import 'package:aleman/feature/order/data/model/order_response_model.dart';

enum OrderDetailsStatus { initial, loading, success, error }

class OrderDetailsState {
  final OrderDetailsStatus status;
  final OrderResponseModel order;
  final bool isCancelling;
  final bool isCancelledSuccessfully;
  final String? errorMessage;
  final String? actionMessage;

  const OrderDetailsState({
    this.status = OrderDetailsStatus.initial,
    required this.order,
    this.isCancelling = false,
    this.isCancelledSuccessfully = false,
    this.errorMessage,
    this.actionMessage,
  });

  OrderDetailsState copyWith({
    OrderDetailsStatus? status,
    OrderResponseModel? order,
    bool? isCancelling,
    bool? isCancelledSuccessfully,
    String? errorMessage,
    String? actionMessage,
  }) {
    return OrderDetailsState(
      status: status ?? this.status,
      order: order ?? this.order,
      isCancelling: isCancelling ?? this.isCancelling,
      isCancelledSuccessfully:
          isCancelledSuccessfully ?? this.isCancelledSuccessfully,
      errorMessage: errorMessage,
      actionMessage: actionMessage,
    );
  }
}
