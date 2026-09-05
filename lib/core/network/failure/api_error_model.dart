import 'package:json_annotation/json_annotation.dart';
part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  ApiErrorModel({
    this.status,
    this.title,
    this.detail,
    this.type,
    this.message,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  final int? status;
  final String? title;
  final String? detail;
  final String? type;
  
  // Legacy or manually set message
  final String? message;

  // Helper to get the most relevant error text
  String get getMessage => detail ?? message ?? title ?? 'Unknown error occurred';

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
}