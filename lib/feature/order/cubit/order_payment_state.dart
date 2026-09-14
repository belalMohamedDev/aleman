import 'dart:io';
import 'package:aleman/feature/order/data/model/bank_account_model.dart';

enum OrderPaymentStatus {
  initial,
  loadingAccounts,
  accountsLoaded,
  fileSelected,
  uploadingReceipt,
  uploadSuccess,
  error,
}

class OrderPaymentState {
  final OrderPaymentStatus status;
  final String orderId;
  final File? selectedFile;
  final String? uploadedReceiptUrl;
  final List<BankAccountModel> bankAccounts;
  final String? errorMessage;
  final String? successMessage;

  const OrderPaymentState({
    this.status = OrderPaymentStatus.initial,
    required this.orderId,
    this.selectedFile,
    this.uploadedReceiptUrl,
    this.bankAccounts = const [],
    this.errorMessage,
    this.successMessage,
  });

  bool get isUploading => status == OrderPaymentStatus.uploadingReceipt;
  bool get hasSelectedFile => selectedFile != null;
  bool get isSuccess => status == OrderPaymentStatus.uploadSuccess;

  OrderPaymentState copyWith({
    OrderPaymentStatus? status,
    String? orderId,
    File? selectedFile,
    bool clearSelectedFile = false,
    String? uploadedReceiptUrl,
    List<BankAccountModel>? bankAccounts,
    String? errorMessage,
    String? successMessage,
  }) {
    return OrderPaymentState(
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      selectedFile: clearSelectedFile ? null : (selectedFile ?? this.selectedFile),
      uploadedReceiptUrl: uploadedReceiptUrl ?? this.uploadedReceiptUrl,
      bankAccounts: bankAccounts ?? this.bankAccounts,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
