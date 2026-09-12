class CreateVehicleRequest {
  final String driverName;
  final String vehiclePlateNumber;
  final String? driverLicenseNumber;
  final String? driverPhone;
  final String? vehicleType;
  final String? notes;
  final bool isDefault;

  const CreateVehicleRequest({
    required this.driverName,
    required this.vehiclePlateNumber,
    this.driverLicenseNumber,
    this.driverPhone,
    this.vehicleType,
    this.notes,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'driverName': driverName.trim(),
      'vehiclePlateNumber': vehiclePlateNumber.trim(),
      'isDefault': isDefault,
    };
    if (driverLicenseNumber != null && driverLicenseNumber!.trim().isNotEmpty) {
      map['driverLicenseNumber'] = driverLicenseNumber!.trim();
    }
    if (driverPhone != null && driverPhone!.trim().isNotEmpty) {
      map['driverPhone'] = driverPhone!.trim();
    }
    if (vehicleType != null && vehicleType!.trim().isNotEmpty) {
      map['vehicleType'] = vehicleType!.trim();
    }
    if (notes != null && notes!.trim().isNotEmpty) {
      map['notes'] = notes!.trim();
    }
    return map;
  }
}
