import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'phoneNumber')
  final String phoneNumber;
  @JsonKey(name: 'role')
  final String role;
  @JsonKey(name: 'profileImageUrl')
  final String? profileImageUrl;
  @JsonKey(name: 'smallMerchants')
  final List<SmallMerchantModel>? smallMerchants;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profileImageUrl,
    this.smallMerchants,
  });

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? role,
    String? profileImageUrl,
    List<SmallMerchantModel>? smallMerchants,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      smallMerchants: smallMerchants ?? this.smallMerchants,
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}

@JsonSerializable()
class SmallMerchantModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'phoneNumber')
  final String phoneNumber;
  @JsonKey(name: 'role')
  final String role;
  @JsonKey(name: 'profileImageUrl')
  final String? profileImageUrl;

  const SmallMerchantModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profileImageUrl,
  });

  factory SmallMerchantModel.fromJson(Map<String, dynamic> json) =>
      _$SmallMerchantModelFromJson(json);

  Map<String, dynamic> toJson() => _$SmallMerchantModelToJson(this);
}
