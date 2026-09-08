class UserAddressModel {
  final String id;
  final String label;
  final String city;
  final String? street;
  final String? district;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final bool isDefault;

  const UserAddressModel({
    required this.id,
    required this.label,
    required this.city,
    this.street,
    this.district,
    this.latitude,
    this.longitude,
    this.notes,
    this.isDefault = false,
  });

  String get fullAddress {
    final parts = [city, district, street]
        .where((p) => p != null && p.trim().isNotEmpty)
        .toList();
    if (parts.isEmpty) return label;
    return parts.join(' - ');
  }

  factory UserAddressModel.fromJson(Map<String, dynamic> json) =>
      UserAddressModel(
        id: json['id']?.toString() ?? '',
        label: json['label'] as String? ?? '',
        city: json['city'] as String? ?? '',
        street: json['street'] as String?,
        district: json['district'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        notes: json['notes'] as String?,
        isDefault: json['isDefault'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'city': city,
        'street': street,
        'district': district,
        'latitude': latitude,
        'longitude': longitude,
        'notes': notes,
        'isDefault': isDefault,
      };
}
