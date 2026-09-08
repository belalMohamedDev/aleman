/*
import 'package:elminiawy/core/common/shared/shared_imports.dart';
import 'package:elminiawy/feature/client/order/presentation/widget/order_details/driver_information_widget.dart';
import 'package:elminiawy/feature/client/order/presentation/widget/order_details/order_id_widget.dart';
import 'package:elminiawy/feature/client/order/presentation/widget/order_details/order_product_list_widget.dart';
import 'package:elminiawy/feature/client/order/presentation/widget/order_details/order_shipping_info_widget.dart';
import 'package:elminiawy/feature/client/order/presentation/widget/order_details/order_stepper_widget.dart';

class OrderDetailsBody extends StatelessWidget {
  final GetOrdersResponseData? order;
  const OrderDetailsBody({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        state.whenOrNull(
          createCashOrderLoading: () => context.pop(),
          createCashOrderError: (apiErrorModel) => ShowToast.showToastErrorTop(
            errorMessage: apiErrorModel.message!,
            context: context,
          ),
          createCashOrderSuccess: (createOrderResponse) {
            if (order != null) {
              ShowToast.showToastSuccessTop(
                message: context.translate(AppStrings.successToCancelOrder),
                context: context,
              );
              context.pop();
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!context.mounted) return;
                await Future.wait([
                  context.read<PaymentCubit>().getCompleteOrdersSummit(),
                  context.read<PaymentCubit>().getOrdersPendingSummit(),
                ]);
              });
            }
          },
        );
      },
      builder: (context, state) {
        final createOrderResponse = context
            .read<PaymentCubit>()
            .createOrderResponseData;

        return Padding(
          padding: responsive.setPadding(top: 2, bottom: 5, left: 5, right: 5),
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        OrderIdWidget(
                          orderResponse: createOrderResponse,
                          order: order,
                        ),
                        responsive.setSizeBox(height: 1),
                        OrderStepperWidget(
                          orderResponse: createOrderResponse,
                          order: order,
                        ),
                        responsive.setSizeBox(height: 1),
                        OrderShippingInfoWidget(
                          orderResponse: createOrderResponse,
                          order: order,
                        ),
                        responsive.setSizeBox(height: 1),
                        if (order?.driverId != null) ...[
                          DriverInformationWidget(order: order),
                          responsive.setSizeBox(height: 1),
                        ],
                      ],
                    ),
                  ),
                  OrderProductListWidget(
                    orderResponse: createOrderResponse,
                    order: order,
                  ),
                ],
              ),
              if (state is CreateCashOrderLoading)
                Center(
                  child: Container(
                    height: responsive.setHeight(10),
                    width: responsive.setWidth(22),
                    decoration: BoxDecoration(
                      color: ColorManger.brun,
                      borderRadius: BorderRadius.circular(
                        responsive.setBorderRadius(2),
                      ),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorManger.white,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

*/
