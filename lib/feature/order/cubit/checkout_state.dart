import 'dart:io';
import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:aleman/feature/order/data/model/calculate_shipping_model.dart';
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
  final int currentStep;
  final OrderType orderType;
  final List<UserAddressModel> addresses;
  final UserAddressModel? selectedAddress;
  final TruckType? selectedTruckType;
  final double shippingFee;
  final String? estimatedDelivery;

  // New shipping details
  final int requiredTrucksCount;
  final double singleTruckFee;
  final double totalOriginalShippingFee;
  final double shippingDiscountAmount;
  final ShippingPromotionInfo? shippingPromotion;
  final Map<int, ShippingPromotionInfo> truckPromotions;
  final ShippingRecommendationModel? shippingRecommendation;

  final List<UserVehicleModel> vehicles;
  final UserVehicleModel? selectedVehicle;
  final String driverName;
  final String vehiclePlateNumber;
  final String driverLicenseNumber;
  final DateTime? expectedPickupDate;
  final bool saveVehicle;

  final PaymentMethodType paymentMethod;
  final File? receiptFile;
  final String? paymentReceiptUrl;
  final bool isUploadingReceipt;
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
    this.selectedTruckType,
    this.shippingFee = 0.0,
    this.estimatedDelivery,
    this.requiredTrucksCount = 1,
    this.singleTruckFee = 0.0,
    this.totalOriginalShippingFee = 0.0,
    this.shippingDiscountAmount = 0.0,
    this.shippingPromotion,
    this.truckPromotions = const {},
    this.shippingRecommendation,
    this.totalWeightTons = 0.0,
    this.vehicles = const [],
    this.selectedVehicle,
    this.driverName = '',
    this.vehiclePlateNumber = '',
    this.driverLicenseNumber = '',
    this.expectedPickupDate,
    this.saveVehicle = false,
    this.paymentMethod = PaymentMethodType.cashOnDelivery,
    this.receiptFile,
    this.paymentReceiptUrl,
    this.isUploadingReceipt = false,
    this.couponCode,
    this.discount = 0.0,
    this.isApplyingCoupon = false,
    this.notes,
    this.errorMessage,
    this.createdOrder,
  });

  bool get isWesal => orderType == OrderType.delivery;
  bool get isFactoryPickup => orderType == OrderType.factoryPickup;

  bool get hasTruckPromotion =>
      shippingPromotion != null ||
      shippingDiscountAmount > 0 ||
      truckPromotions.isNotEmpty;

  int get totalSteps => isWesal ? 4 : 3;
  bool get isLastStep => currentStep == totalSteps;

  List<String> get stepTitles => isWesal
      ? const ['الاستلام', 'الشاحنة', 'الدفع', 'المراجعة']
      : const ['الاستلام', 'الدفع', 'المراجعة'];

  CheckoutState copyWith({
    CheckoutStatus? status,
    int? currentStep,
    OrderType? orderType,
    List<UserAddressModel>? addresses,
    UserAddressModel? selectedAddress,
    TruckType? selectedTruckType,
    double? shippingFee,
    String? estimatedDelivery,
    int? requiredTrucksCount,
    double? singleTruckFee,
    double? totalOriginalShippingFee,
    double? shippingDiscountAmount,
    ShippingPromotionInfo? shippingPromotion,
    bool clearShippingPromotion = false,
    Map<int, ShippingPromotionInfo>? truckPromotions,
    ShippingRecommendationModel? shippingRecommendation,
    bool clearShippingRecommendation = false,
    double? totalWeightTons,
    List<UserVehicleModel>? vehicles,
    UserVehicleModel? selectedVehicle,
    String? driverName,
    String? vehiclePlateNumber,
    String? driverLicenseNumber,
    DateTime? expectedPickupDate,
    bool? saveVehicle,
    PaymentMethodType? paymentMethod,
    File? receiptFile,
    bool clearReceiptFile = false,
    String? paymentReceiptUrl,
    bool clearPaymentReceiptUrl = false,
    bool? isUploadingReceipt,
    String? couponCode,
    double? discount,
    bool? isApplyingCoupon,
    String? notes,
    String? errorMessage,
    OrderResponseModel? createdOrder,
    bool clearSelectedAddress = false,
    bool clearSelectedVehicle = false,
    bool clearSelectedTruckType = false,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      orderType: orderType ?? this.orderType,
      addresses: addresses ?? this.addresses,
      selectedAddress: clearSelectedAddress
          ? null
          : (selectedAddress ?? this.selectedAddress),
      selectedTruckType: clearSelectedTruckType
          ? null
          : (selectedTruckType ?? this.selectedTruckType),
      shippingFee: shippingFee ?? this.shippingFee,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      requiredTrucksCount: requiredTrucksCount ?? this.requiredTrucksCount,
      singleTruckFee: singleTruckFee ?? this.singleTruckFee,
      totalOriginalShippingFee:
          totalOriginalShippingFee ?? this.totalOriginalShippingFee,
      shippingDiscountAmount:
          shippingDiscountAmount ?? this.shippingDiscountAmount,
      shippingPromotion: clearShippingPromotion
          ? null
          : (shippingPromotion ?? this.shippingPromotion),
      truckPromotions: truckPromotions ?? this.truckPromotions,
      shippingRecommendation: clearShippingRecommendation
          ? null
          : (shippingRecommendation ?? this.shippingRecommendation),
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
      receiptFile: clearReceiptFile ? null : (receiptFile ?? this.receiptFile),
      paymentReceiptUrl: clearPaymentReceiptUrl
          ? null
          : (paymentReceiptUrl ?? this.paymentReceiptUrl),
      isUploadingReceipt: isUploadingReceipt ?? this.isUploadingReceipt,
      couponCode: couponCode ?? this.couponCode,
      discount: discount ?? this.discount,
      isApplyingCoupon: isApplyingCoupon ?? this.isApplyingCoupon,
      notes: notes ?? this.notes,
      errorMessage: errorMessage,
      createdOrder: createdOrder ?? this.createdOrder,
    );
  }
}
