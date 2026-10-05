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
            backgroundColor: Colors.grey.shade50,
            appBar: AppBar(
              title: const Text(
                'إتمام الشراء',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.grey.shade50,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  if (state.currentStep > 1) {
                    cubit.previousStep();
                  } else {
                    Navigator.of(context).maybePop();
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
    final isWesalBeforeTruck = state.isWesal && state.currentStep == 1;
    final shipping = (state.isFactoryPickup || isWesalBeforeTruck)
        ? 0.0
        : state.shippingFee;
    final finalTotal = (cartSubtotal - state.discount + shipping).clamp(
      0.0,
      double.infinity,
    );

    final cart = context.read<CartCubit>().state.cart;
    final totalWeightStr = cart != null
        ? (cart.totalWeightTons > 0
              ? '${cart.totalWeightTons.toStringAsFixed(1)} طن'
              : (cart.totalWeightKg > 0
                    ? '${cart.totalWeightKg.toStringAsFixed(1)} كجم'
                    : ''))
        : (state.totalWeightTons > 0
              ? '${state.totalWeightTons.toStringAsFixed(1)} طن'
              : '');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Total Price Section
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'المجموع',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (totalWeightStr.isNotEmpty) ...[
                        Text(
                          ' ($totalWeightStr)',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${_formatPrice(finalTotal)} ج.م.',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  CustomPaint(
                    size: Size(double.infinity, 2.h),
                    painter: const _DottedLinePainter(color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),

            SizedBox(width: 20.w),

            // Next Step / Submit Order Button
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
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
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
                          !state.isLastStep
                              ? 'احفظ واستمر'
                              : 'تأكيد وإرسال الطلب',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final parts = price.toStringAsFixed(2).split('.');
    final wholePart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$wholePart.${parts[1]}';
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;

  const _DottedLinePainter({this.color = const Color(0xFF94A3B8)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round;

    const dotRadius = 0.8;
    const dotSpacing = 3.0;
    double currentX = 0;

    while (currentX < size.width) {
      canvas.drawCircle(Offset(currentX, size.height / 2), dotRadius, paint);
      currentX += dotSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
