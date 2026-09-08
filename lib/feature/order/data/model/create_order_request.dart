class CreateOrderRequest {
  final int orderType; // 1: وصال, 2: أرض المصنع
  final String? addressId;
  final int? truckType;
  final String? driverName;
  final String? vehiclePlateNumber;
  final String? driverLicenseNumber;
  final String? expectedPickupDate;
  final int paymentMethod;
  final String? couponCode;
  final String? notes;

  const CreateOrderRequest({
    required this.orderType,
    this.addressId,
    this.truckType,
    this.driverName,
    this.vehiclePlateNumber,
    this.driverLicenseNumber,
    this.expectedPickupDate,
    required this.paymentMethod,
    this.couponCode,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'orderType': orderType,
      'paymentMethod': paymentMethod,
    };
    if (addressId != null) map['addressId'] = addressId;
    if (truckType != null) map['truckType'] = truckType;
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
