import 'package:aleman/feature/notification/data/model/response/notification_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notifications_list_response.g.dart';

@JsonSerializable()
class NotificationsListResponse {
  final List<NotificationItemModel>? notifications;
  final int? unreadCount;
  final int? totalCount;
  final int? page;
  final int? pageSize;
  final int? totalPages;

  const NotificationsListResponse({
    this.notifications,
    this.unreadCount,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory NotificationsListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsListResponseToJson(this);
}
