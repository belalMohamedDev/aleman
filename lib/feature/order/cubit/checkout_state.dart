import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:aleman/feature/order/data/model/enums/order_enums.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/vehicle/data/model/user_vehicle_model.dart';

enum CheckoutStatus {
  initial,
  loadingAddresses,
  calculatingShipping,
  submitting,
  success,
  error,
}

class CheckoutState {
  final CheckoutStatus status;
  final int currentStep; // 1: استلام وشحن, 2: دفع, 3: مراجعة
  final OrderType orderType;
  final List<UserAddressModel> addresses;
  final UserAddressModel? selectedAddress;
  final TruckType? selectedTruckType;
  final double shippingFee;
  final String? estimatedDelivery;

  final List<UserVehicleModel> vehicles;
  final UserVehicleModel? selectedVehicle;
  final String driverName;
  final String vehiclePlateNumber;
  final String driverLicenseNumber;
  final DateTime? expectedPickupDate;
  final bool saveVehicle;

  final PaymentMethodType paymentMethod;
  final String? couponCode;
  final double discount;
  final bool isApplyingCoupon;

  final String? notes;

  final double totalWeightTons;

  final String? errorMessage;
  final OrderResponseModel? createdOrder;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.currentStep = 1,
    this.orderType = OrderType.delivery,
    this.addresses = const [],
    this.selectedAddress,
    this.selectedTruckType = TruckType.dababa,
    this.shippingFee = 0.0,
    this.estimatedDelivery,
    this.totalWeightTons = 0.0,
    this.vehicles = const [],
    this.selectedVehicle,
    this.driverName = '',
    this.vehiclePlateNumber = '',
    this.driverLicenseNumber = '',
    this.expectedPickupDate,
    this.saveVehicle = false,
    this.paymentMethod = PaymentMethodType.cashOnDelivery,
    this.couponCode,
    this.discount = 0.0,
    this.isApplyingCoupon = false,
    this.notes,
    this.errorMessage,
    this.createdOrder,
  });

  bool get isWesal => orderType == OrderType.delivery;
  bool get isFactoryPickup => orderType == OrderType.factoryPickup;

  CheckoutState copyWith({
    CheckoutStatus? status,
    int? currentStep,
    OrderType? orderType,
    List<UserAddressModel>? addresses,
    UserAddressModel? selectedAddress,
    TruckType? selectedTruckType,
    double? shippingFee,
    String? estimatedDelivery,
    double? totalWeightTons,
    List<UserVehicleModel>? vehicles,
    UserVehicleModel? selectedVehicle,
    String? driverName,
    String? vehiclePlateNumber,
    String? driverLicenseNumber,
    DateTime? expectedPickupDate,
    bool? saveVehicle,
    PaymentMethodType? paymentMethod,
    String? couponCode,
    double? discount,
    bool? isApplyingCoupon,
    String? notes,
    String? errorMessage,
    OrderResponseModel? createdOrder,
    bool clearSelectedAddress = false,
    bool clearSelectedVehicle = false,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      orderType: orderType ?? this.orderType,
      addresses: addresses ?? this.addresses,
      selectedAddress: clearSelectedAddress
          ? null
          : (selectedAddress ?? this.selectedAddress),
      selectedTruckType: selectedTruckType ?? this.selectedTruckType,
      shippingFee: shippingFee ?? this.shippingFee,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      totalWeightTons: totalWeightTons ?? this.totalWeightTons,
      vehicles: vehicles ?? this.vehicles,
      selectedVehicle: clearSelectedVehicle
          ? null
          : (selectedVehicle ?? this.selectedVehicle),
      driverName: driverName ?? this.driverName,
      vehiclePlateNumber: vehiclePlateNumber ?? this.vehiclePlateNumber,
      driverLicenseNumber: driverLicenseNumber ?? this.driverLicenseNumber,
      expectedPickupDate: expectedPickupDate ?? this.expectedPickupDate,
      saveVehicle: saveVehicle ?? this.saveVehicle,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      couponCode: couponCode ?? this.couponCode,
      discount: discount ?? this.discount,
      isApplyingCoupon: isApplyingCoupon ?? this.isApplyingCoupon,
      notes: notes ?? this.notes,
      errorMessage: errorMessage,
      createdOrder: createdOrder ?? this.createdOrder,
    );
  }
}
