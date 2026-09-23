// ignore_for_file: deprecated_member_use

import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/address/data/repository/address_repo.dart';
import 'package:aleman/feature/address/presentation/widget/add_address_bottom_sheet.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/order/cubit/checkout_cubit.dart';
import 'package:aleman/feature/order/cubit/checkout_state.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:aleman/feature/order/presentation/screen/order_success_screen.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/checkout_stepper_header.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/step1/order_fulfillment_step_widget.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/step1/truck_type_selector_widget.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/step2/payment_methods_widget.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/step3/review_step_widget.dart';
import 'package:aleman/feature/vehicle/data/repository/vehicle_repo.dart';
import 'package:aleman/feature/vehicle/logic/cubit/vehicle_cubit.dart';
import 'package:aleman/feature/vehicle/presentation/widget/add_edit_vehicle_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final totalWeightTons = cartCubit.state.cart?.totalWeightTons ?? 0.0;

    return BlocProvider(
      create: (context) =>
          CheckoutCubit(
              instance<OrderRepository>(),
              instance<UserAddressRepository>(),
              instance<UserVehicleRepository>(),
            )
            ..initFromCart(totalWeightTons: totalWeightTons)
            ..loadAddresses()
            ..loadVehicles(),
      child: const _CheckoutScreenContent(),
    );
  }
}

class _CheckoutScreenContent extends StatelessWidget {
  const _CheckoutScreenContent();

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final cartSubtotal = cartCubit.state.cart?.totalPrice ?? 0.0;

    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state.status == CheckoutStatus.success &&
            state.createdOrder != null) {
          cartCubit.clearCart();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderSuccessScreen(order: state.createdOrder!),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CheckoutCubit>();

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: const Color(0xFFF9F9FB),
            appBar: AppBar(
              title: const Text(
                'إتمام الشراء',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black87,
                ),
                onPressed: () {
                  if (state.currentStep > 1) {
                    cubit.previousStep();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: Column(
              children: [
                CheckoutStepperHeader(
                  currentStep: state.currentStep,
                  steps: state.stepTitles,
                ),

                // Step Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: _buildStepBody(context, state, cubit, cartSubtotal),
                  ),
                ),

                _buildBottomBar(context, state, cubit, cartSubtotal),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepBody(
    BuildContext context,
    CheckoutState state,
    CheckoutCubit cubit,
    double cartSubtotal,
  ) {
    if (state.isWesal) {
      switch (state.currentStep) {
        case 1:
          return OrderFulfillmentStepWidget(
            orderType: state.orderType,
            onOrderTypeChanged: cubit.changeOrderType,
            addresses: state.addresses,
            selectedAddress: state.selectedAddress,
            onAddressSelected: cubit.selectAddress,
            onAddNewAddress: () {
              AddAddressBottomSheet.show(
                context,
                onAddressAdded: (address) {
                  cubit.loadAddresses();
                  cubit.selectAddress(address);
                },
              );
            },
            vehicles: state.vehicles,
            selectedVehicle: state.selectedVehicle,
            onVehicleSelected: cubit.selectVehicle,
            expectedPickupDate: state.expectedPickupDate,
            onDateChanged: (date) => cubit.updateDriverInfo(date: date),
            onAddNewVehicle: () {
              AddEditVehicleBottomSheet.show(
                context,
                vehicleCubit: VehicleCubit(instance<UserVehicleRepository>()),
                onVehicleSaved: (newVehicle) {
                  cubit.loadVehicles();
                  cubit.selectVehicle(newVehicle);
                },
              );
            },
          );

        case 2:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TruckTypeSelectorWidget(
                selectedTruck: state.selectedTruckType,
                onTruckSelected: cubit.selectTruckType,
                currentShippingFee: state.shippingFee,
                isCalculating:
                    state.status == CheckoutStatus.calculatingShipping,
                estimatedDelivery: state.estimatedDelivery,
                totalWeightTons: state.totalWeightTons,
                requiredTrucksCount: state.requiredTrucksCount,
                singleTruckFee: state.singleTruckFee,
                totalOriginalShippingFee: state.totalOriginalShippingFee,
                shippingDiscountAmount: state.shippingDiscountAmount,
                shippingPromotion: state.shippingPromotion,
                truckPromotions: state.truckPromotions,
                shippingRecommendation: state.shippingRecommendation,
                onApplyRecommendation: cubit.applyRecommendedTruck,
              ),
              SizedBox(height: 20.h),
            ],
          );

        case 3:
          final shipping = state.shippingFee;
          final currentTotal = (cartSubtotal - state.discount + shipping).clamp(
            0.0,
            double.infinity,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentMethodsWidget(
                selectedMethod: state.paymentMethod,
                onMethodSelected: cubit.selectPaymentMethod,
                receiptFile: state.receiptFile,
                paymentReceiptUrl: state.paymentReceiptUrl,
                isUploadingReceipt: state.isUploadingReceipt,
                onPickReceipt: cubit.pickAndUploadReceipt,
                onPickReceiptPdf: cubit.pickAndUploadReceiptPdf,
                onRemoveReceipt: cubit.removeReceipt,
                totalAmount: currentTotal,
              ),
              SizedBox(height: 20.h),
            ],
          );

        case 4:
          return ReviewStepWidget(
            state: state,
            cartSubtotal: cartSubtotal,
            onNotesChanged: cubit.updateNotes,
          );

        default:
          return const SizedBox.shrink();
      }
    } else {
      // Factory Pickup Flow (3 steps)
      switch (state.currentStep) {
        case 1:
          return OrderFulfillmentStepWidget(
            orderType: state.orderType,
            onOrderTypeChanged: cubit.changeOrderType,
            addresses: state.addresses,
            selectedAddress: state.selectedAddress,
            onAddressSelected: cubit.selectAddress,
            onAddNewAddress: () {},
            vehicles: state.vehicles,
            selectedVehicle: state.selectedVehicle,
            onVehicleSelected: cubit.selectVehicle,
            expectedPickupDate: state.expectedPickupDate,
            onDateChanged: (date) => cubit.updateDriverInfo(date: date),
            onAddNewVehicle: () {
              AddEditVehicleBottomSheet.show(
                context,
                vehicleCubit: VehicleCubit(instance<UserVehicleRepository>()),
                onVehicleSaved: (newVehicle) {
                  cubit.loadVehicles();
                  cubit.selectVehicle(newVehicle);
                },
              );
            },
          );

        case 2:
          final currentTotal = (cartSubtotal - state.discount).clamp(
            0.0,
            double.infinity,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentMethodsWidget(
                selectedMethod: state.paymentMethod,
                onMethodSelected: cubit.selectPaymentMethod,
                receiptFile: state.receiptFile,
                paymentReceiptUrl: state.paymentReceiptUrl,
                isUploadingReceipt: state.isUploadingReceipt,
                onPickReceipt: cubit.pickAndUploadReceipt,
                onPickReceiptPdf: cubit.pickAndUploadReceiptPdf,
                onRemoveReceipt: cubit.removeReceipt,
                totalAmount: currentTotal,
              ),
              SizedBox(height: 20.h),
            ],
          );

        case 3:
          return ReviewStepWidget(
            state: state,
            cartSubtotal: cartSubtotal,
            onNotesChanged: cubit.updateNotes,
          );

        default:
          return const SizedBox.shrink();
      }
    }
  }

  Widget _buildBottomBar(
    BuildContext context,
    CheckoutState state,
    CheckoutCubit cubit,
    double cartSubtotal,
  ) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      return const SizedBox.shrink();
    }

    final isSubmitting = state.status == CheckoutStatus.submitting;
    final shipping = state.isFactoryPickup ? 0.0 : state.shippingFee;
    final finalTotal = (cartSubtotal - state.discount + shipping).clamp(
      0.0,
      double.infinity,
    );

    if (state.isLastStep) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الإجمالي النهائي',
                    style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$finalTotal ج.م',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManger.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : cubit.submitOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManger.primaryLight,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: isSubmitting
                        ? SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline, size: 20.sp),
                              SizedBox(width: 6.w),
                              Text(
                                'تأكيد وإرسال الطلب',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'سعر الطلبات',
                  style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                ),
                Text(
                  '$cartSubtotal ج.م',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),

            state.isFactoryPickup
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'سعر الشحن',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        (state.currentStep == 1
                            ? 'في الخطوة التالية'
                            : (state.status ==
                                      CheckoutStatus.calculatingShipping
                                  ? 'جاري الحساب...'
                                  : (state.selectedTruckType == null
                                        ? 'اختر سيارة الشحن'
                                        : '${state.shippingFee} ج.م'))),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              state.currentStep == 1 ||
                                  state.selectedTruckType == null
                              ? Colors.grey.shade600
                              : ColorManger.goldDark,
                        ),
                      ),
                    ],
                  ),

            if (state.totalWeightTons > 0) ...[
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'إجمالي الكمية (الوزن)',
                    style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                  ),
                  Text(
                    '${state.totalWeightTons} طن',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],

            Divider(height: 16.h, color: Colors.grey.shade300),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الإجمالي',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.primary,
                  ),
                ),
                Text(
                  '$finalTotal ج.م',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManger.goldDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              if (!state.isLastStep) {
                                cubit.nextStep();
                              } else {
                                cubit.submitOrder();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManger.primaryLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              !state.isLastStep ? 'احفظ واستمر' : 'تقديم الطلب',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
