import 'dart:convert';

import 'package:aleman/feature/notification/data/model/response/notification_item_model.dart';
import 'package:aleman/feature/notification/data/model/response/notifications_list_response.dart';
import 'package:aleman/feature/notification/domain/entity/notification_item_entity.dart';
import 'package:aleman/feature/notification/domain/entity/notifications_pagination_entity.dart';

extension NotificationItemModelMapper on NotificationItemModel? {
  NotificationItemEntity toEntity() {
    Map<String, dynamic> parsedData = {};

    if (this?.data != null) {
      if (this!.data is Map) {
        parsedData = Map<String, dynamic>.from(this!.data as Map);
      } else if (this!.data is String && (this!.data as String).trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(this!.data as String);
          if (decoded is Map) {
            parsedData = Map<String, dynamic>.from(decoded);
          }
        } catch (_) {
          // If not valid JSON, ignore or keep empty
        }
      }
    }

    DateTime? parsedCreatedAt;
    if (this?.createdAt != null && this!.createdAt!.isNotEmpty) {
      try {
        parsedCreatedAt = DateTime.parse(this!.createdAt!);
      } catch (_) {}
    }

    return NotificationItemEntity(
      id: this?.id ?? 0,
      title: this?.title ?? '',
      body: this?.body ?? '',
      data: parsedData,
      isRead: this?.isRead ?? false,
      createdAt: parsedCreatedAt,
    );
  }
}

extension NotificationsListResponseMapper on NotificationsListResponse? {
  NotificationsPaginationEntity toEntity() {
    final list = (this?.notifications ?? [])
        .map((item) => item.toEntity())
        .toList();

    return NotificationsPaginationEntity(
      notifications: list,
      unreadCount: this?.unreadCount ?? 0,
      totalCount: this?.totalCount ?? 0,
      page: this?.page ?? 1,
      pageSize: this?.pageSize ?? 20,
      totalPages: this?.totalPages ?? 1,
    );
  }
}
