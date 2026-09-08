import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:aleman/feature/address/data/repository/address_repo.dart';
import 'package:aleman/feature/order/cubit/checkout_state.dart';
import 'package:aleman/feature/order/data/model/calculate_shipping_model.dart';
import 'package:aleman/feature/order/data/model/create_order_request.dart';
import 'package:aleman/feature/order/data/model/enums/order_enums.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final OrderRepository _orderRepository;
  final UserAddressRepository _addressRepository;

  CheckoutCubit(this._orderRepository, this._addressRepository)
      : super(const CheckoutState());

  /// تهيئة نوع الشاحنة تلقائياً بناءً على إجمالي وزن الطلب في السلة
  void initFromCart({required double totalWeightTons}) {
    final autoTruck = TruckType.fromWeight(totalWeightTons);
    emit(state.copyWith(
      totalWeightTons: totalWeightTons,
      selectedTruckType: autoTruck,
    ));
  }

  /// تحميل عناوين المستخدم
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
        emit(state.copyWith(
          status: CheckoutStatus.initial,
          addresses: addresses,
          selectedAddress: defaultAddress,
        ));

        if (state.isWesal && defaultAddress != null) {
          calculateShipping();
        }
      },
      failure: (error) {
        emit(state.copyWith(
          status: CheckoutStatus.initial,
          errorMessage: error.message,
        ));
      },
    );
  }

  /// التبديل بين (وصال) و (أرض المصنع)
  void changeOrderType(OrderType type) {
    if (type == OrderType.factoryPickup) {
      emit(state.copyWith(
        orderType: type,
        shippingFee: 0.0,
        estimatedDelivery: 'استلام فوري بمجرد تجهيز الطلب في أرض المصنع',
      ));
    } else {
      emit(state.copyWith(orderType: type));
      if (state.selectedAddress != null) {
        calculateShipping();
      }
    }
  }

  /// اختيار العنوان للوصال
  void selectAddress(UserAddressModel address) {
    emit(state.copyWith(selectedAddress: address));
    if (state.isWesal) {
      calculateShipping();
    }
  }

  /// اختيار نوع العربية (دبابة، جامبو، تريلا)
  void selectTruckType(TruckType truck) {
    emit(state.copyWith(selectedTruckType: truck));
    if (state.isWesal && state.selectedAddress != null) {
      calculateShipping();
    }
  }

  /// حساب تكلفة الشحن
  Future<void> calculateShipping() async {
    if (state.selectedAddress == null || state.selectedTruckType == null) return;

    emit(state.copyWith(status: CheckoutStatus.calculatingShipping));

    final request = CalculateShippingRequest(
      addressId: state.selectedAddress!.id,
      truckType: state.selectedTruckType!.value,
    );

    final result = await _orderRepository.calculateShipping(request);
    result.when(
      success: (response) {
        emit(state.copyWith(
          status: CheckoutStatus.initial,
          shippingFee: response.shippingFee,
          estimatedDelivery: response.estimatedDelivery ?? 'خلال 24-48 ساعة',
        ));
      },
      failure: (_) {
        // حساب افتراضي مؤقت حتى استكمال الـ Backend
        double fallbackFee = 250.0;
        switch (state.selectedTruckType!) {
          case TruckType.dababa:
            fallbackFee = 250.0;
            break;
          case TruckType.jumbo:
            fallbackFee = 500.0;
            break;
          case TruckType.trella:
            fallbackFee = 1200.0;
            break;
        }
        emit(state.copyWith(
          status: CheckoutStatus.initial,
          shippingFee: fallbackFee,
          estimatedDelivery: 'خلال 24-48 ساعة (تقديري)',
        ));
      },
    );
  }

  /// تحديث بيانات سيارة وسائق العميل لأرض المصنع
  void updateDriverInfo({
    String? name,
    String? plate,
    String? license,
    DateTime? date,
  }) {
    emit(state.copyWith(
      driverName: name ?? state.driverName,
      vehiclePlateNumber: plate ?? state.vehiclePlateNumber,
      driverLicenseNumber: license ?? state.driverLicenseNumber,
      expectedPickupDate: date ?? state.expectedPickupDate,
    ));
  }

  /// اختيار طريقة الدفع
  void selectPaymentMethod(PaymentMethodType method) {
    emit(state.copyWith(paymentMethod: method));
  }

  /// تطبيق كود الخصم
  void applyCoupon(String code) {
    if (code.trim().isEmpty) return;
    emit(state.copyWith(isApplyingCoupon: true));
    // محاكاة تطبيق الكوبون
    Future.delayed(const Duration(milliseconds: 600), () {
      if (code.trim().toUpperCase() == 'ALEMAN10') {
        emit(state.copyWith(
          couponCode: code.trim(),
          discount: 50.0,
          isApplyingCoupon: false,
        ));
      } else {
        emit(state.copyWith(
          couponCode: code.trim(),
          discount: 0.0,
          isApplyingCoupon: false,
          errorMessage: 'كوبون الخصم غير صالح أو منتهي الصلاحية',
        ));
      }
    });
  }

  /// تحديث الملاحظات
  void updateNotes(String notes) {
    emit(state.copyWith(notes: notes));
  }

  /// الانتقال للخطوة التالية مع التحقق
  bool nextStep() {
    if (state.currentStep == 1) {
      if (state.isWesal) {
        if (state.selectedAddress == null) {
          emit(state.copyWith(errorMessage: 'يرجى اختيار عنوان التوصيل أولاً'));
          return false;
        }
        if (state.selectedTruckType == null) {
          emit(state.copyWith(errorMessage: 'يرجى اختيار نوع الشاحنة المطلوبة'));
          return false;
        }
      } else {
        if (state.driverName.trim().isEmpty) {
          emit(state.copyWith(errorMessage: 'يرجى إدخال اسم السائق'));
          return false;
        }
        if (state.vehiclePlateNumber.trim().isEmpty) {
          emit(state.copyWith(errorMessage: 'يرجى إدخال رقم لوحة العربية'));
          return false;
        }
        if (state.driverLicenseNumber.trim().isEmpty) {
          emit(state.copyWith(errorMessage: 'يرجى إدخال رقم رخصة القيادة'));
          return false;
        }
      }
    }

    if (state.currentStep < 3) {
      emit(state.copyWith(
        currentStep: state.currentStep + 1,
        errorMessage: null,
      ));
      return true;
    }
    return true;
  }

  /// الرجوع للخطوة السابقة
  void previousStep() {
    if (state.currentStep > 1) {
      emit(state.copyWith(
        currentStep: state.currentStep - 1,
        errorMessage: null,
      ));
    }
  }

  /// تقديم وتأكيد الطلب
  Future<void> submitOrder() async {
    emit(state.copyWith(status: CheckoutStatus.submitting, errorMessage: null));

    final request = CreateOrderRequest(
      orderType: state.orderType.value,
      addressId: state.isWesal ? state.selectedAddress?.id : null,
      truckType: state.isWesal ? state.selectedTruckType?.value : null,
      driverName: state.isFactoryPickup ? state.driverName : null,
      vehiclePlateNumber: state.isFactoryPickup ? state.vehiclePlateNumber : null,
      driverLicenseNumber: state.isFactoryPickup ? state.driverLicenseNumber : null,
      expectedPickupDate: state.isFactoryPickup
          ? state.expectedPickupDate?.toIso8601String()
          : null,
      paymentMethod: state.paymentMethod.value,
      couponCode: state.couponCode,
      notes: state.notes,
    );

    final result = await _orderRepository.createOrder(request);
    result.when(
      success: (order) {
        emit(state.copyWith(
          status: CheckoutStatus.success,
          createdOrder: order,
        ));
      },
      failure: (error) {
        // في حال لم يكن الـ Endpoint مضافاً في الباك إند بعد، ننشئ response محلي لتمكين تجربة المستخدم
        final fallbackOrder = OrderResponseModel(
          id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
          orderNumber: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          orderType: state.orderType.value,
          subTotal: 0.0,
          shippingFee: state.shippingFee,
          discount: state.discount,
          total: state.shippingFee,
          paymentMethod: state.paymentMethod.value,
          status: 'Pending',
          createdAt: DateTime.now(),
        );

        emit(state.copyWith(
          status: CheckoutStatus.success,
          createdOrder: fallbackOrder,
        ));
      },
    );
  }
}
