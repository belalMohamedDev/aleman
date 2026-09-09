import 'package:aleman/feature/notification/domain/entity/notification_item_entity.dart';

enum NotificationStatus { initial, loading, success, error, loadingMore }

class NotificationState {
  final NotificationStatus status;
  final List<NotificationItemEntity> notifications;
  final int unreadCount;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final String? errorMessage;
  final String? successMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.totalCount = 0,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
    this.errorMessage,
    this.successMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationItemEntity>? notifications,
    int? unreadCount,
    int? totalCount,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    String? errorMessage,
    String? successMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
