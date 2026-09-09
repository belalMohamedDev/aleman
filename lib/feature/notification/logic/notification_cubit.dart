import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/notification/domain/entity/notification_item_entity.dart';
import 'package:aleman/feature/notification/domain/usecase/get_notifications_use_case.dart';
import 'package:aleman/feature/notification/domain/usecase/get_unread_count_use_case.dart';
import 'package:aleman/feature/notification/domain/usecase/mark_all_notifications_read_use_case.dart';
import 'package:aleman/feature/notification/domain/usecase/mark_notification_read_use_case.dart';
import 'package:aleman/feature/notification/logic/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final GetUnreadCountUseCase _getUnreadCountUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase _markAllNotificationsReadUseCase;

  NotificationCubit(
    this._getNotificationsUseCase,
    this._getUnreadCountUseCase,
    this._markNotificationReadUseCase,
    this._markAllNotificationsReadUseCase,
  ) : super(const NotificationState());

  Future<void> getNotifications({bool refresh = false}) async {
    if (refresh) {
      emit(state.copyWith(
        status: NotificationStatus.loading,
        currentPage: 1,
      ));
    } else if (state.notifications.isEmpty) {
      emit(state.copyWith(status: NotificationStatus.loading));
    } else if (state.hasMore && state.status != NotificationStatus.loadingMore) {
      emit(state.copyWith(status: NotificationStatus.loadingMore));
    } else {
      return;
    }

    final pageToLoad = refresh ? 1 : (state.currentPage + 1);

    final result = await _getNotificationsUseCase.execute(
      page: pageToLoad,
      limit: 20,
    );

    result.when(
      success: (paginationEntity) {
        final List<NotificationItemEntity> updatedList = refresh
            ? paginationEntity.notifications
            : [...state.notifications, ...paginationEntity.notifications];

        emit(state.copyWith(
          status: NotificationStatus.success,
          notifications: updatedList,
          unreadCount: paginationEntity.unreadCount,
          totalCount: paginationEntity.totalCount,
          currentPage: paginationEntity.page,
          totalPages: paginationEntity.totalPages,
          hasMore: paginationEntity.hasMore,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: NotificationStatus.error,
          errorMessage: error.message,
        ));
      },
    );
  }

  Future<void> getUnreadCount() async {
    final result = await _getUnreadCountUseCase.execute();
    result.when(
      success: (count) {
        emit(state.copyWith(unreadCount: count));
      },
      failure: (_) {},
    );
  }

  Future<void> markAsRead(int notificationId) async {
    // Optimistic UI update
    final updatedList = state.notifications.map((item) {
      if (item.id == notificationId && !item.isRead) {
        return item.copyWith(isRead: true);
      }
      return item;
    }).toList();

    final newUnreadCount = (state.unreadCount > 0) ? (state.unreadCount - 1) : 0;

    emit(state.copyWith(
      notifications: updatedList,
      unreadCount: newUnreadCount,
    ));

    await _markNotificationReadUseCase.execute(notificationId);
  }

  Future<void> markAllAsRead() async {
    if (state.notifications.isEmpty || state.unreadCount == 0) return;

    // Optimistic UI update
    final updatedList = state.notifications.map((item) {
      return item.copyWith(isRead: true);
    }).toList();

    emit(state.copyWith(
      notifications: updatedList,
      unreadCount: 0,
    ));

    final result = await _markAllNotificationsReadUseCase.execute();
    result.when(
      success: (res) {
        emit(state.copyWith(successMessage: res.message));
      },
      failure: (error) {
        emit(state.copyWith(errorMessage: error.message));
      },
    );
  }
}
