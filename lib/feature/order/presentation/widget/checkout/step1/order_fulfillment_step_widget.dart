import 'package:aleman/feature/address/data/model/user_address_model.dart';
import 'package:aleman/feature/order/data/model/enums/order_enums.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/step1/address_selection_widget.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/step1/factory_pickup_form_widget.dart';
import 'package:aleman/feature/order/presentation/widget/checkout/step1/order_type_selector.dart';
import 'package:aleman/feature/vehicle/data/model/user_vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderFulfillmentStepWidget extends StatelessWidget {
  final OrderType orderType;
  final ValueChanged<OrderType> onOrderTypeChanged;

  // Wesal / Delivery props
  final List<UserAddressModel> addresses;
  final UserAddressModel? selectedAddress;
  final ValueChanged<UserAddressModel> onAddressSelected;
  final VoidCallback onAddNewAddress;

  // Factory Pickup props
  final List<UserVehicleModel> vehicles;
  final UserVehicleModel? selectedVehicle;
  final ValueChanged<UserVehicleModel> onVehicleSelected;
  final DateTime? expectedPickupDate;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback onAddNewVehicle;

  const OrderFulfillmentStepWidget({
    super.key,
    required this.orderType,
    required this.onOrderTypeChanged,
    required this.addresses,
    required this.selectedAddress,
    required this.onAddressSelected,
    required this.onAddNewAddress,
    required this.vehicles,
    required this.selectedVehicle,
    required this.onVehicleSelected,
    required this.expectedPickupDate,
    required this.onDateChanged,
    required this.onAddNewVehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrderTypeSelector(
          selectedType: orderType,
          onTypeChanged: onOrderTypeChanged,
        ),
        SizedBox(height: 18.h),
        if (orderType == OrderType.delivery) ...[
          AddressSelectionWidget(
            addresses: addresses,
            selectedAddress: selectedAddress,
            onAddressSelected: onAddressSelected,
            onAddNewAddress: onAddNewAddress,
          ),
        ] else ...[
          FactoryPickupFormWidget(
            vehicles: vehicles,
            selectedVehicle: selectedVehicle,
            onVehicleSelected: onVehicleSelected,
            expectedPickupDate: expectedPickupDate,
            onDateChanged: onDateChanged,
            onAddNewVehicle: onAddNewVehicle,
          ),
        ],
        SizedBox(height: 20.h),
      ],
    );
  }
}
