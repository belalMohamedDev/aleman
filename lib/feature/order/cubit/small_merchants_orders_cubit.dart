import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/order/cubit/small_merchants_orders_state.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmallMerchantsOrdersCubit extends Cubit<SmallMerchantsOrdersState> {
  final OrderRepository _orderRepository;

  SmallMerchantsOrdersCubit(this._orderRepository)
    : super(const SmallMerchantsOrdersState());

  Future<void> loadOrders({bool refresh = false}) async {
    if (state.status == SmallMerchantsOrdersStatus.loading && !refresh) return;

    emit(
      state.copyWith(
        status: refresh ? state.status : SmallMerchantsOrdersStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _orderRepository.getSmallMerchantsOrders(
      page: 1,
      pageSize: 10,
    );

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            status: SmallMerchantsOrdersStatus.success,
            orders: response.orders,
            currentPage: response.page,
            totalPages: response.totalPages,
            totalCount: response.totalCount,
          ),
        );
      },
      failure: (errorHandler) {
        emit(
          state.copyWith(
            status: SmallMerchantsOrdersStatus.error,
            errorMessage: errorHandler.getMessage,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.status == SmallMerchantsOrdersStatus.loadingMore ||
        state.status == SmallMerchantsOrdersStatus.loading) {
      return;
    }

    emit(state.copyWith(status: SmallMerchantsOrdersStatus.loadingMore));

    final nextPage = state.currentPage + 1;
    final result = await _orderRepository.getSmallMerchantsOrders(
      page: nextPage,
      pageSize: 10,
    );

    result.when(
      success: (response) {
        final allOrders = <OrderResponseModel>[
          ...state.orders,
          ...response.orders,
        ];
        emit(
          state.copyWith(
            status: SmallMerchantsOrdersStatus.success,
            orders: allOrders,
            currentPage: response.page,
            totalPages: response.totalPages,
            totalCount: response.totalCount,
          ),
        );
      },
      failure: (errorHandler) {
        // Stop loadingMore without clearing existing list
        emit(
          state.copyWith(
            status: SmallMerchantsOrdersStatus.success,
            errorMessage: errorHandler.getMessage,
          ),
        );
      },
    );
  }

  void filterByStatus(int? status) {
    if (status == null) {
      emit(state.copyWith(clearStatus: true));
    } else {
      emit(state.copyWith(selectedStatus: status));
    }
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
