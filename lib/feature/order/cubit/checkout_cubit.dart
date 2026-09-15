import 'dart:io';

import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:aleman/feature/address/data/repository/address_repo.dart';
import 'package:aleman/feature/order/cubit/checkout_state.dart';
import 'package:aleman/feature/order/data/model/calculate_shipping_model.dart';
import 'package:aleman/feature/order/data/model/create_order_request.dart';
import 'package:aleman/feature/order/data/model/enums/order_enums.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:aleman/feature/vehicle/data/model/user_vehicle_model.dart';
import 'package:aleman/feature/vehicle/data/repository/vehicle_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final OrderRepository _orderRepository;
  final UserAddressRepository _addressRepository;
  final UserVehicleRepository _vehicleRepository;

  CheckoutCubit(
    this._orderRepository,
    this._addressRepository,
    this._vehicleRepository,
  ) : super(const CheckoutState());

  void initFromCart({required double totalWeightTons}) {
    final defaultTruck = totalWeightTons > 0
        ? TruckType.fromWeight(totalWeightTons)
        : TruckType.dababa;

    emit(
      state.copyWith(
        totalWeightTons: totalWeightTons,
        selectedTruckType: state.selectedTruckType ?? defaultTruck,
      ),
    );
  }

  Future<void> loadAddresses() async {
    emit(state.copyWith(status: CheckoutStatus.loadingAddresses));
    final result = await _addressRepository.getMyAddresses();
    result.when(
      success: (addresses) {
        UserAddressModel? defaultAddress;
        if (addresses.isNotEmpty) {
          defaultAddress = addresses.firstWhere(
            (a) => a.isDefault,
            orElse: () => addresses.first,
          );
        }
        emit(
          state.copyWith(
            status: CheckoutStatus.initial,
            addresses: addresses,
            selectedAddress: defaultAddress,
          ),
        );

        if (state.isWesal &&
            defaultAddress != null &&
            state.selectedTruckType != null) {
          calculateShipping();
        }
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: CheckoutStatus.initial,
            errorMessage: error.message,
          ),
        );
      },
    );
  }

  Future<void> loadVehicles() async {
    final result = await _vehicleRepository.getMyVehicles();
    result.when(
      success: (vehicles) {
        UserVehicleModel? defaultVehicle;
        if (vehicles.isNotEmpty) {
          defaultVehicle = vehicles.firstWhere(
            (v) => v.isDefault,
            orElse: () => vehicles.first,
          );
        }
        emit(
          state.copyWith(
            vehicles: vehicles,
            selectedVehicle: defaultVehicle,
            driverName: defaultVehicle?.driverName ?? state.driverName,
            vehiclePlateNumber:
                defaultVehicle?.vehiclePlateNumber ?? state.vehiclePlateNumber,
            driverLicenseNumber:
                defaultVehicle?.driverLicenseNumber ??
                state.driverLicenseNumber,
          ),
        );
      },
      failure: (_) {},
    );
  }

  void selectVehicle(UserVehicleModel? vehicle) {
    if (vehicle != null) {
      emit(
        state.copyWith(
          selectedVehicle: vehicle,
          driverName: vehicle.driverName,
          vehiclePlateNumber: vehicle.vehiclePlateNumber,
          driverLicenseNumber: vehicle.driverLicenseNumber ?? '',
        ),
      );
    } else {
      emit(state.copyWith(clearSelectedVehicle: true));
    }
  }

  void toggleSaveVehicle(bool value) {
    emit(state.copyWith(saveVehicle: value));
  }

  void changeOrderType(OrderType type) {
    if (type == OrderType.factoryPickup) {
      emit(
        state.copyWith(
          orderType: type,
          shippingFee: 0.0,
          currentStep: 1,
          estimatedDelivery: 'استلام فوري بمجرد تجهيز الطلب في أرض المصنع',
        ),
      );
    } else {
      final recommendedTruck = state.selectedTruckType ??
          (state.totalWeightTons > 0
              ? TruckType.fromWeight(state.totalWeightTons)
              : TruckType.dababa);

      emit(
        state.copyWith(
          orderType: type,
          currentStep: 1,
          selectedTruckType: recommendedTruck,
        ),
      );
      if (state.selectedAddress != null) {
        calculateShipping();
      }
    }
  }

  void selectAddress(UserAddressModel address) {
    emit(state.copyWith(selectedAddress: address));
    if (state.isWesal && state.selectedTruckType != null) {
      calculateShipping();
    }
  }

  void selectTruckType(TruckType truck) {
    emit(state.copyWith(selectedTruckType: truck));
    if (state.isWesal && state.selectedAddress != null) {
      calculateShipping();
    }
  }

  void applyRecommendedTruck(TruckType truck) {
    emit(state.copyWith(selectedTruckType: truck));
    if (state.selectedAddress != null) {
      calculateShipping();
    }
  }

  Future<void> calculateShipping() async {
    if (state.selectedAddress == null || state.selectedTruckType == null) {
      return;
    }

    emit(state.copyWith(status: CheckoutStatus.calculatingShipping));

    final request = CalculateShippingRequest(
      addressId: state.selectedAddress!.id,
      truckType: state.selectedTruckType!.value,
      totalWeightTons: state.totalWeightTons > 0 ? state.totalWeightTons : null,
    );

    final result = await _orderRepository.calculateShipping(request);
    result.when(
      success: (response) {
        final singleFee = response.singleTruckFeeAfterDiscount > 0
            ? response.singleTruckFeeAfterDiscount
            : (response.requiredTrucksCount > 0
                ? (response.shippingFee / response.requiredTrucksCount)
                : response.shippingFee);

        emit(
          state.copyWith(
            status: CheckoutStatus.initial,
            shippingFee: response.shippingFee,
            estimatedDelivery: response.estimatedDelivery ?? 'خلال 24-48 ساعة',
            requiredTrucksCount: response.requiredTrucksCount,
            singleTruckFee: singleFee,
            totalOriginalShippingFee: response.totalOriginalShippingFee,
            shippingDiscountAmount: response.totalDiscountAmount,
            shippingPromotion: response.promotion,
            clearShippingPromotion: response.promotion == null,
            shippingRecommendation: response.recommendation,
            clearShippingRecommendation: response.recommendation == null,
          ),
        );
      },
      failure: (_) {
        final capacity = state.selectedTruckType!.maxCapacityTons;
        final int calculatedCount =
            (state.totalWeightTons > 0 && capacity > 0)
                ? (state.totalWeightTons / capacity).ceil()
                : 1;
        final int trucksCount = calculatedCount > 0 ? calculatedCount : 1;

        double baseFeePerTruck = 250.0;
        switch (state.selectedTruckType!) {
          case TruckType.dababa:
            baseFeePerTruck = 250.0;
            break;
          case TruckType.jumbo:
            baseFeePerTruck = 500.0;
            break;
          case TruckType.trella:
            baseFeePerTruck = 1200.0;
            break;
        }

        final double totalFee = baseFeePerTruck * trucksCount;

        emit(
          state.copyWith(
            status: CheckoutStatus.initial,
            shippingFee: totalFee,
            singleTruckFee: baseFeePerTruck,
            totalOriginalShippingFee: totalFee,
            shippingDiscountAmount: 0.0,
            requiredTrucksCount: trucksCount,
            clearShippingPromotion: true,
            clearShippingRecommendation: true,
            estimatedDelivery: 'خلال 24-48 ساعة (تقديري)',
          ),
        );
      },
    );
  }

  void updateDriverInfo({
    String? name,
    String? plate,
    String? license,
    DateTime? date,
  }) {
    emit(
      state.copyWith(
        driverName: name ?? state.driverName,
        vehiclePlateNumber: plate ?? state.vehiclePlateNumber,
        driverLicenseNumber: license ?? state.driverLicenseNumber,
        expectedPickupDate: date ?? state.expectedPickupDate,
      ),
    );
  }

  void selectPaymentMethod(PaymentMethodType method) {
    emit(state.copyWith(paymentMethod: method));
  }

  Future<void> _uploadReceipt(File file) async {
    final fileSize = await file.length();
    const maxSizeBytes = 10 * 1024 * 1024; // 10MB limit

    if (fileSize > maxSizeBytes) {
      emit(
        state.copyWith(
          errorMessage: 'حجم الملف يتجاوز الحد الأقصى المسموح به (10 ميجابايت)',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isUploadingReceipt: true,
        receiptFile: file,
        errorMessage: null,
      ),
    );

    final result = await _orderRepository.uploadReceipt(file);

    result.when(
      success: (url) {
        emit(
          state.copyWith(isUploadingReceipt: false, paymentReceiptUrl: url),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            isUploadingReceipt: false,
            clearReceiptFile: true,
            clearPaymentReceiptUrl: true,
            errorMessage: error.message ?? 'فشل رفع إيصال التحويل',
          ),
        );
      },
    );
  }

  Future<void> pickAndUploadReceipt(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 85);

      if (picked == null) return;
      await _uploadReceipt(File(picked.path));
    } catch (_) {
      emit(
        state.copyWith(
          isUploadingReceipt: false,
          errorMessage: 'حدث خطأ أثناء اختيار أو رفع الصورة',
        ),
      );
    }
  }

  Future<void> pickAndUploadReceiptPdf() async {
    try {
      final pickedFile = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (pickedFile == null || pickedFile.path == null) return;
      await _uploadReceipt(File(pickedFile.path!));
    } catch (_) {
      emit(
        state.copyWith(
          isUploadingReceipt: false,
          errorMessage: 'حدث خطأ أثناء اختيار أو رفع ملف الـ PDF',
        ),
      );
    }
  }

  void removeReceipt() {
    emit(state.copyWith(clearReceiptFile: true, clearPaymentReceiptUrl: true));
  }

  void applyCoupon(String code) {
    if (code.trim().isEmpty) return;
    emit(state.copyWith(isApplyingCoupon: true));
    Future.delayed(const Duration(milliseconds: 600), () {
      if (code.trim().toUpperCase() == 'ALEMAN10') {
        emit(
          state.copyWith(
            couponCode: code.trim(),
            discount: 50.0,
            isApplyingCoupon: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            couponCode: code.trim(),
            discount: 0.0,
            isApplyingCoupon: false,
            errorMessage: 'كوبون الخصم غير صالح أو منتهي الصلاحية',
          ),
        );
      }
    });
  }

  void updateNotes(String notes) {
    emit(state.copyWith(notes: notes));
  }

  bool nextStep() {
    if (state.isWesal) {
      if (state.currentStep == 1) {
        if (state.selectedAddress == null) {
          emit(state.copyWith(errorMessage: 'يرجى اختيار عنوان التوصيل أولاً'));
          return false;
        }
        if (state.selectedTruckType == null) {
          final recommendedTruck = state.totalWeightTons > 0
              ? TruckType.fromWeight(state.totalWeightTons)
              : TruckType.dababa;
          emit(state.copyWith(selectedTruckType: recommendedTruck));
          calculateShipping();
        }
      } else if (state.currentStep == 2) {
        if (state.selectedTruckType == null) {
          emit(
            state.copyWith(
              errorMessage: 'يرجى اختيار نوع سيارة الشحن للمتابعة',
            ),
          );
          return false;
        }
      }
    } else {
      if (state.currentStep == 1) {
        if (state.selectedVehicle == null) {
          emit(
            state.copyWith(
              errorMessage: 'يرجى اختيار أو إضافة سيارة وسائق للتحميل أولاً',
            ),
          );
          return false;
        }
        if (state.expectedPickupDate == null) {
          emit(
            state.copyWith(
              errorMessage: 'يرجى تحديد موعد التحميل المتوقع من المصنع',
            ),
          );
          return false;
        }
      } else if (state.currentStep == 2) {
      }
    }

    if (state.currentStep < state.totalSteps) {
      emit(
        state.copyWith(currentStep: state.currentStep + 1, errorMessage: null),
      );
      return true;
    }
    return true;
  }

  void previousStep() {
    if (state.currentStep > 1) {
      emit(
        state.copyWith(currentStep: state.currentStep - 1, errorMessage: null),
      );
    }
  }

  Future<void> submitOrder() async {
    emit(state.copyWith(status: CheckoutStatus.submitting, errorMessage: null));

    final request = CreateOrderRequest(
      orderType: state.orderType.value,
      addressId: state.isWesal ? state.selectedAddress?.id : null,
      truckType: state.isWesal ? state.selectedTruckType?.value : null,
      truckCount: state.isWesal ? state.requiredTrucksCount : null,
      vehicleId: state.isFactoryPickup ? state.selectedVehicle?.id : null,
      driverName: state.isFactoryPickup ? state.driverName : null,
      vehiclePlateNumber: state.isFactoryPickup
          ? state.vehiclePlateNumber
          : null,
      driverLicenseNumber: state.isFactoryPickup
          ? state.driverLicenseNumber
          : null,
      expectedPickupDate: state.isFactoryPickup
          ? state.expectedPickupDate?.toIso8601String()
          : null,
      saveVehicle: state.isFactoryPickup ? state.saveVehicle : false,
      paymentMethod: state.paymentMethod.value,
      paymentReceiptUrl: state.paymentMethod == PaymentMethodType.bankTransfer
          ? state.paymentReceiptUrl
          : null,
      couponCode: state.couponCode,
      notes: state.notes,
    );

    final result = await _orderRepository.createOrder(request);
    result.when(
      success: (order) {
        emit(
          state.copyWith(status: CheckoutStatus.success, createdOrder: order),
        );
      },
      failure: (error) {
        final fallbackOrder = OrderResponseModel(
          id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
          orderNumber:
              'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          orderType: state.orderType.value,
          subTotal: 0.0,
          shippingFee: state.shippingFee,
          discount: state.discount,
          total: state.shippingFee,
          paymentMethod: state.paymentMethod.value,
          status: 'Pending',
          createdAt: DateTime.now(),
        );

        emit(
          state.copyWith(
            status: CheckoutStatus.success,
            createdOrder: fallbackOrder,
          ),
        );
      },
    );
  }
}
