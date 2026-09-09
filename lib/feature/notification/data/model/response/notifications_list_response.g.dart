// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsListResponse _$NotificationsListResponseFromJson(
  Map<String, dynamic> json,
) => NotificationsListResponse(
  notifications: (json['notifications'] as List<dynamic>?)
      ?.map((e) => NotificationItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  unreadCount: (json['unreadCount'] as num?)?.toInt(),
  totalCount: (json['totalCount'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationsListResponseToJson(
  NotificationsListResponse instance,
) => <String, dynamic>{
  'notifications': instance.notifications,
  'unreadCount': instance.unreadCount,
  'totalCount': instance.totalCount,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalPages': instance.totalPages,
};
