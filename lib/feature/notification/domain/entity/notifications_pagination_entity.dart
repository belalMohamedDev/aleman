import 'package:aleman/feature/notification/domain/entity/notification_item_entity.dart';

class NotificationsPaginationEntity {
  final List<NotificationItemEntity> notifications;
  final int unreadCount;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  const NotificationsPaginationEntity({
    required this.notifications,
    required this.unreadCount,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;
}
