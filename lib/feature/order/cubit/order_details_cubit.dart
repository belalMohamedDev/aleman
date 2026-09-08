import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/order/cubit/order_details_state.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrderRepository _orderRepository;

  OrderDetailsCubit(
    this._orderRepository, {
    required OrderResponseModel initialOrder,
  }) : super(OrderDetailsState(order: initialOrder));

  Future<void> fetchOrderDetails() async {
    emit(state.copyWith(status: OrderDetailsStatus.loading));
    final result = await _orderRepository.getOrderDetails(state.order.id);
    result.when(
      success: (detailedOrder) {
        emit(state.copyWith(
          status: OrderDetailsStatus.success,
          order: detailedOrder,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: OrderDetailsStatus.error,
          errorMessage: error.message ?? 'فشل في تحديث بيانات الطلب',
        ));
      },
    );
  }

  Future<bool> cancelOrder() async {
    emit(state.copyWith(isCancelling: true, errorMessage: null));
    final result = await _orderRepository.cancelOrder(state.order.id);
    return result.when(
      success: (_) {
        final updatedOrder = OrderResponseModel(
          id: state.order.id,
          orderNumber: state.order.orderNumber,
          orderType: state.order.orderType,
          orderTypeName: state.order.orderTypeName,
          subTotal: state.order.subTotal,
          shippingFee: state.order.shippingFee,
          discount: state.order.discount,
          total: state.order.total,
          paymentMethod: state.order.paymentMethod,
          paymentMethodName: state.order.paymentMethodName,
          statusCode: 7,
          status: 'ملغي',
          totalWeightTons: state.order.totalWeightTons,
          totalItemsCount: state.order.totalItemsCount,
          createdAt: state.order.createdAt,
          truckName: state.order.truckName,
          driverName: state.order.driverName,
          vehiclePlateNumber: state.order.vehiclePlateNumber,
          driverLicenseNumber: state.order.driverLicenseNumber,
          expectedPickupDate: state.order.expectedPickupDate,
          addressText: state.order.addressText,
          notes: state.order.notes,
          items: state.order.items,
        );

        emit(state.copyWith(
          isCancelling: false,
          isCancelledSuccessfully: true,
          order: updatedOrder,
          actionMessage: 'تم إلغاء الطلب بنجاح',
        ));
        return true;
      },
      failure: (error) {
        emit(state.copyWith(
          isCancelling: false,
          errorMessage: error.message ?? 'تعذر إلغاء الطلب',
        ));
        return false;
      },
    );
  }
}
