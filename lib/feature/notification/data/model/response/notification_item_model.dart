import 'package:json_annotation/json_annotation.dart';

part 'notification_item_model.g.dart';

@JsonSerializable()
class NotificationItemModel {
  final int? id;
  final String? title;
  final String? body;
  final dynamic data;
  final bool? isRead;
  final String? createdAt;

  const NotificationItemModel({
    this.id,
    this.title,
    this.body,
    this.data,
    this.isRead,
    this.createdAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationItemModelToJson(this);
}
