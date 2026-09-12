class UserVehicleModel {
  final String id;
  final String driverName;
  final String vehiclePlateNumber;
  final String? driverLicenseNumber;
  final String? driverPhone;
  final String? vehicleType;
  final String? notes;
  final bool isDefault;
  final DateTime? createdAt;

  const UserVehicleModel({
    required this.id,
    required this.driverName,
    required this.vehiclePlateNumber,
    this.driverLicenseNumber,
    this.driverPhone,
    this.vehicleType,
    this.notes,
    this.isDefault = false,
    this.createdAt,
  });

  UserVehicleModel copyWith({
    String? id,
    String? driverName,
    String? vehiclePlateNumber,
    String? driverLicenseNumber,
    String? driverPhone,
    String? vehicleType,
    String? notes,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return UserVehicleModel(
      id: id ?? this.id,
      driverName: driverName ?? this.driverName,
      vehiclePlateNumber: vehiclePlateNumber ?? this.vehiclePlateNumber,
      driverLicenseNumber: driverLicenseNumber ?? this.driverLicenseNumber,
      driverPhone: driverPhone ?? this.driverPhone,
      vehicleType: vehicleType ?? this.vehicleType,
      notes: notes ?? this.notes,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  UserVehicleModel copyWithDefault(bool isDefault) {
    return copyWith(isDefault: isDefault);
  }

  factory UserVehicleModel.fromJson(Map<String, dynamic> json) {
    return UserVehicleModel(
      id: json['id']?.toString() ?? '',
      driverName: json['driverName'] as String? ?? '',
      vehiclePlateNumber: json['vehiclePlateNumber'] as String? ?? '',
      driverLicenseNumber: json['driverLicenseNumber'] as String?,
      driverPhone: json['driverPhone'] as String?,
      vehicleType: json['vehicleType'] as String?,
      notes: json['notes'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'driverName': driverName,
        'vehiclePlateNumber': vehiclePlateNumber,
        if (driverLicenseNumber != null)
          'driverLicenseNumber': driverLicenseNumber,
        if (driverPhone != null) 'driverPhone': driverPhone,
        if (vehicleType != null) 'vehicleType': vehicleType,
        if (notes != null) 'notes': notes,
        'isDefault': isDefault,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}
