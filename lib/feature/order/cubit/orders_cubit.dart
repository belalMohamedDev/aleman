import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/order/cubit/orders_state.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepository _repository;

  OrdersCubit(this._repository) : super(const OrdersState());

  void changeTab(int index) {
    emit(state.copyWith(selectedTab: index));
  }

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrdersStatus.loading, errorMessage: null));
    final result = await _repository.getMyOrders();
    result.when(
      success: (orders) {
        emit(state.copyWith(
          status: OrdersStatus.success,
          orders: orders,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: OrdersStatus.error,
          errorMessage: error.message ?? 'فشل في تحميل الطلبات',
        ));
      },
    );
  }

  Future<bool> cancelOrder(String orderId) async {
    emit(state.copyWith(isCancelling: true, errorMessage: null));
    final result = await _repository.cancelOrder(orderId);
    return result.when(
      success: (_) {
        final updatedOrders = state.orders.map((order) {
          if (order.id == orderId) {
            return OrderResponseModel(
              id: order.id,
              orderNumber: order.orderNumber,
              orderType: order.orderType,
              orderTypeName: order.orderTypeName,
              subTotal: order.subTotal,
              shippingFee: order.shippingFee,
              discount: order.discount,
              total: order.total,
              paymentMethod: order.paymentMethod,
              paymentMethodName: order.paymentMethodName,
              statusCode: 7,
              status: 'ملغي',
              totalWeightTons: order.totalWeightTons,
              totalItemsCount: order.totalItemsCount,
              createdAt: order.createdAt,
              truckName: order.truckName,
              driverName: order.driverName,
              vehiclePlateNumber: order.vehiclePlateNumber,
              driverLicenseNumber: order.driverLicenseNumber,
              expectedPickupDate: order.expectedPickupDate,
              addressText: order.addressText,
              notes: order.notes,
              items: order.items,
            );
          }
          return order;
        }).toList();

        emit(state.copyWith(
          isCancelling: false,
          orders: updatedOrders,
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
