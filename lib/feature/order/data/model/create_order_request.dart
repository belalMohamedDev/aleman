class CreateOrderRequest {
  final int orderType; // 1: وصال, 2: أرض المصنع
  final String? addressId;
  final int? truckType;
  final String? vehicleId;
  final String? driverName;
  final String? vehiclePlateNumber;
  final String? driverLicenseNumber;
  final String? expectedPickupDate;
  final bool saveVehicle;
  final int paymentMethod;
  final String? couponCode;
  final String? notes;

  const CreateOrderRequest({
    required this.orderType,
    this.addressId,
    this.truckType,
    this.vehicleId,
    this.driverName,
    this.vehiclePlateNumber,
    this.driverLicenseNumber,
    this.expectedPickupDate,
    this.saveVehicle = false,
    required this.paymentMethod,
    this.couponCode,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'orderType': orderType,
      'paymentMethod': paymentMethod,
      'saveVehicle': saveVehicle,
    };
    if (addressId != null) map['addressId'] = addressId;
    if (truckType != null) map['truckType'] = truckType;
    if (vehicleId != null && vehicleId!.trim().isNotEmpty) {
      map['vehicleId'] = vehicleId;
    }
    if (driverName != null && driverName!.trim().isNotEmpty) {
      map['driverName'] = driverName;
    }
    if (vehiclePlateNumber != null && vehiclePlateNumber!.trim().isNotEmpty) {
      map['vehiclePlateNumber'] = vehiclePlateNumber;
    }
    if (driverLicenseNumber != null && driverLicenseNumber!.trim().isNotEmpty) {
      map['driverLicenseNumber'] = driverLicenseNumber;
    }
    if (expectedPickupDate != null) {
      map['expectedPickupDate'] = expectedPickupDate;
    }
    if (couponCode != null && couponCode!.trim().isNotEmpty) {
      map['couponCode'] = couponCode;
    }
    if (notes != null && notes!.trim().isNotEmpty) {
      map['notes'] = notes;
    }
    return map;
  }
}
