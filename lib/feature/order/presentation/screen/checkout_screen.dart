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
import 'package:aleman/feature/order/presentation/widget/checkout/step1/address_selection_widget.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/step1/factory_pickup_form_widget.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/step1/order_type_selector.dart';
// import 'package:aleman/feature/order/presentation/widget/checkout/step1/truck_type_selector_widget.dart';
// import 'package:aleman/feature/order/presentation/widget/checkout/step2/coupon_input_widget.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/step2/payment_methods_widget.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/step3/review_step_widget.dart';
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
            )
            ..initFromCart(totalWeightTons: totalWeightTons)
            ..loadAddresses(),
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
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }

        if (state.status == CheckoutStatus.success &&
            state.createdOrder != null) {
          // تفريغ السلة محلياً بعد نجاح الطلب
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
                // Stepper Header (الاستلام - الدفع - المراجعة)
                CheckoutStepperHeader(currentStep: state.currentStep),

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

                // Bottom Navigation Actions (يختفي تلقائياً عند فتح الكيبورد)
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
    switch (state.currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderTypeSelector(
              selectedType: state.orderType,
              onTypeChanged: cubit.changeOrderType,
            ),
            SizedBox(height: 18.h),

            if (state.isWesal) ...[
              AddressSelectionWidget(
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
              ),
              // /* _buildAutoAssignedTruckCard(context, state), */
            ] else ...[
              FactoryPickupFormWidget(
                driverName: state.driverName,
                vehiclePlateNumber: state.vehiclePlateNumber,
                driverLicenseNumber: state.driverLicenseNumber,
                expectedPickupDate: state.expectedPickupDate,
                onInfoChanged: cubit.updateDriverInfo,
              ),
            ],
            SizedBox(height: 20.h),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaymentMethodsWidget(
              selectedMethod: state.paymentMethod,
              onMethodSelected: cubit.selectPaymentMethod,
            ),
            // SizedBox(height: 20.h),
            // CouponInputWidget(
            //   appliedCoupon: state.couponCode,
            //   discountAmount: state.discount,
            //   isApplying: state.isApplyingCoupon,
            //   onApplyCoupon: cubit.applyCoupon,
            // ),
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

    if (state.currentStep == 3) {
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
            // سعر الطلبات
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

            // سعر الشحن
            state.isFactoryPickup
                ? SizedBox.shrink()
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
                        (state.status == CheckoutStatus.calculatingShipping
                            ? 'جاري الحساب...'
                            : '${state.shippingFee} ج.م'),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: state.isFactoryPickup
                              ? Colors.green.shade700
                              : ColorManger.goldDark,
                        ),
                      ),
                    ],
                  ),

            // إجمالي الكمية كوزن
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

            // الإجمالي النهائي
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

            // أزرار التنقل
            Row(
              children: [
                // if (state.currentStep > 1) ...[
                //   OutlinedButton(
                //     onPressed: isSubmitting ? null : cubit.previousStep,
                //     style: OutlinedButton.styleFrom(
                //       foregroundColor: ColorManger.primaryLight,
                //       side: BorderSide(color: ColorManger.primaryLight),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12.r),
                //       ),
                //       minimumSize: Size(80.w, 48.h),
                //     ),
                //     child: const Text('السابق'),
                //   ),
                //   SizedBox(width: 12.w),
                // ],
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              if (state.currentStep < 3) {
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
                              state.currentStep < 3
                                  ? 'احفظ واستمر'
                                  : 'تقديم الطلب',
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

  /*
  Widget _buildAutoAssignedTruckCard(BuildContext context, CheckoutState state) {
    final truck = state.selectedTruckType ?? TruckType.dababa;
    final primary = ColorManger.primaryLight;
    final isCalculating = state.status == CheckoutStatus.calculatingShipping;

    IconData truckIcon = Icons.local_shipping_outlined;
    switch (truck) {
      case TruckType.dababa:
        truckIcon = Icons.airport_shuttle_outlined;
        break;
      case TruckType.jumbo:
        truckIcon = Icons.local_shipping_outlined;
        break;
      case TruckType.trella:
        truckIcon = Icons.fire_truck_outlined;
        break;
    }

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: primary.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(truckIcon, color: primary, size: 26.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'سيارة الشحن المحددة: ',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          truck.title,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'تم تحديدها تلقائياً بحسب حمولة السلة (${state.totalWeightTons} طن)',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: ColorManger.goldDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 20.h, color: Colors.grey.shade200),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تكلفة الشحن المقدرة للمنطقة',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorManger.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (state.estimatedDelivery != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      state.estimatedDelivery!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                isCalculating ? '...' : '${state.shippingFee} ج.م',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManger.goldDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  */
}
