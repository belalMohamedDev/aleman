import 'package:aleman/core/application/di.dart';
import 'package:aleman/feature/order/cubit/order_payment_cubit.dart';
import 'package:aleman/feature/order/cubit/order_payment_state.dart';
import 'package:aleman/feature/order/data/model/order_response_model.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
// import 'package:aleman/feature/order/presentation/widget/order_details/payment/factory_bank_accounts_card.dart';
import 'package:aleman/feature/order/presentation/widget/order_details/payment/order_awaiting_admin_card.dart';
import 'package:aleman/feature/order/presentation/widget/order_details/payment/order_awaiting_merchant_card.dart';
import 'package:aleman/feature/order/presentation/widget/order_details/payment/payment_approved_card.dart';
import 'package:aleman/feature/order/presentation/widget/order_details/payment/payment_rejection_card.dart';
import 'package:aleman/feature/order/presentation/widget/order_details/payment/receipt_under_review_card.dart';
import 'package:aleman/feature/order/presentation/widget/order_details/payment/receipt_upload_action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderBankTransferFlowWidget extends StatelessWidget {
  final OrderResponseModel order;
  final VoidCallback? onOrderUpdated;

  const OrderBankTransferFlowWidget({
    super.key,
    required this.order,
    this.onOrderUpdated,
  });

  @override
  Widget build(BuildContext context) {
    if (!order.isBankTransfer) {
      return const SizedBox.shrink();
    }

    if (order.isCancelled) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      create: (_) => OrderPaymentCubit(
        instance<OrderRepository>(),
        orderId: order.id,
        existingReceiptUrl: order.paymentReceiptUrl,
      ),
      child: _BankTransferFlowContent(
        order: order,
        onOrderUpdated: onOrderUpdated,
      ),
    );
  }
}

class _BankTransferFlowContent extends StatelessWidget {
  final OrderResponseModel order;
  final VoidCallback? onOrderUpdated;

  const _BankTransferFlowContent({required this.order, this.onOrderUpdated});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderPaymentCubit, OrderPaymentState>(
      builder: (context, paymentState) {
        if (order.isPendingMerchantApproval) {
          return OrderAwaitingMerchantCard(
            parentMerchantName: order.parentMerchantName,
          );
        }

        if (order.isPendingAdminApproval) {
          return OrderAwaitingAdminCard(
            isAfterMerchantApproval: order.merchantApprovedAt != null,
          );
        }

        if (order.isPaymentApproved) {
          return PaymentApprovedCard(
            approvedAt: order.paymentApprovedAt,
            receiptUrl:
                order.paymentReceiptUrl ?? paymentState.uploadedReceiptUrl,
          );
        }

        final effectiveReceiptUrl =
            paymentState.uploadedReceiptUrl ?? order.paymentReceiptUrl;
        if (effectiveReceiptUrl != null &&
            effectiveReceiptUrl.isNotEmpty &&
            !order.isPaymentReceiptRejected &&
            paymentState.status != OrderPaymentStatus.fileSelected) {
          return ReceiptUnderReviewCard(
            receiptUrl: effectiveReceiptUrl,
            uploadedAt: order.paymentReceiptUploadedAt,
            onReUploadRequested: () {
              context.read<OrderPaymentCubit>().clearSelectedFile();
            },
          );
        }

        // final requiredAmount = order.total > 0
        //     ? order.total
        //     : (order.subTotal > 0 ? order.subTotal : 0.0);

        if (order.isPaymentReceiptRejected) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentRejectionCard(
                rejectionReason: order.paymentRejectionReason,
              ),
              SizedBox(height: 14.h),
              // if (paymentState.bankAccounts.isNotEmpty) ...[
              //   FactoryBankAccountsCard(
              //     accounts: paymentState.bankAccounts,
              //     totalAmount: requiredAmount,
              //   ),
              //   SizedBox(height: 14.h),
              // ],
              ReceiptUploadActionCard(onUploadSuccess: onOrderUpdated),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (paymentState.bankAccounts.isNotEmpty) ...[
            //   FactoryBankAccountsCard(
            //     accounts: paymentState.bankAccounts,
            //     totalAmount: requiredAmount,
            //   ),
            //   SizedBox(height: 14.h),
            // ],
            ReceiptUploadActionCard(onUploadSuccess: onOrderUpdated),
          ],
        );
      },
    );
  }
}
