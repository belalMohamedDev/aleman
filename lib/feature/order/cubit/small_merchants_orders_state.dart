import 'package:aleman/feature/order/data/model/order_response_model.dart';

enum SmallMerchantsOrdersStatus { initial, loading, success, error, loadingMore }

class SmallMerchantsOrdersState {
  final SmallMerchantsOrdersStatus status;
  final List<OrderResponseModel> orders;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int? selectedStatus; // null: All, 1: Pending, 2-5: Processing, 6: Completed, 7: Cancelled
  final String searchQuery;

  const SmallMerchantsOrdersState({
    this.status = SmallMerchantsOrdersStatus.initial,
    this.orders = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalCount = 0,
    this.selectedStatus,
    this.searchQuery = '',
  });

  bool get hasMore => currentPage < totalPages;

  List<OrderResponseModel> get _scopedOrders {
    if (searchQuery.trim().isEmpty) return orders;
    final query = searchQuery.trim().toLowerCase();
    return orders.where((o) {
      final customerMatch =
          (o.customerName ?? '').toLowerCase().contains(query);
      final orderNumMatch = o.orderNumber.toLowerCase().contains(query);
      final userIdMatch = (o.userId ?? '').toLowerCase().contains(query);
      return customerMatch || orderNumMatch || userIdMatch;
    }).toList();
  }

  List<OrderResponseModel> get filteredOrders {
    var result = _scopedOrders;

    if (selectedStatus != null) {
      if (selectedStatus == 1) {
        result = result.where((o) => o.statusCode == 1).toList();
      } else if (selectedStatus == 2) {
        // قيد التجهيز / النقل (2, 3, 4, 5)
        result = result.where((o) => o.statusCode >= 2 && o.statusCode <= 5).toList();
      } else if (selectedStatus == 6) {
        result = result.where((o) => o.statusCode == 6).toList();
      } else if (selectedStatus == 7) {
        result = result.where((o) => o.statusCode == 7).toList();
      }
    }

    return result;
  }

  int get totalFilteredCount => _scopedOrders.length;
  int get pendingCount => _scopedOrders.where((o) => o.statusCode == 1).length;
  int get inProgressCount =>
      _scopedOrders.where((o) => o.statusCode >= 2 && o.statusCode <= 5).length;
  int get completedCount => _scopedOrders.where((o) => o.statusCode == 6).length;
  int get cancelledCount => _scopedOrders.where((o) => o.statusCode == 7).length;

  SmallMerchantsOrdersState copyWith({
    SmallMerchantsOrdersStatus? status,
    List<OrderResponseModel>? orders,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    int? totalCount,
    int? selectedStatus,
    bool clearStatus = false,
    String? searchQuery,
  }) {
    return SmallMerchantsOrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      selectedStatus:
          clearStatus ? null : (selectedStatus ?? this.selectedStatus),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
