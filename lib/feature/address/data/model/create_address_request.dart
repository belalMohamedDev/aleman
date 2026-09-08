class CreateAddressRequest {
  final String label;
  final String city;
  final String? street;
  final String? district;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final bool isDefault;

  const CreateAddressRequest({
    required this.label,
    required this.city,
    this.street,
    this.district,
    this.latitude,
    this.longitude,
    this.notes,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
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
