import 'dart:io';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/order/cubit/order_payment_state.dart';
import 'package:aleman/feature/order/data/repository/order_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class OrderPaymentCubit extends Cubit<OrderPaymentState> {
  final OrderRepository _orderRepository;

  OrderPaymentCubit(
    this._orderRepository, {
    required String orderId,
    String? existingReceiptUrl,
  }) : super(OrderPaymentState(
          orderId: orderId,
          uploadedReceiptUrl: existingReceiptUrl,
        )) {
    loadBankAccounts();
  }

  Future<void> loadBankAccounts() async {
    emit(state.copyWith(status: OrderPaymentStatus.loadingAccounts));
    final result = await _orderRepository.getBankAccounts();
    result.when(
      success: (accounts) {
        emit(state.copyWith(
          status: OrderPaymentStatus.accountsLoaded,
          bankAccounts: accounts,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: OrderPaymentStatus.accountsLoaded,
          errorMessage: error.message ?? 'فشل في تحميل حسابات المصنع البنكية',
        ));
      },
    );
  }

  Future<void> pickImageReceipt(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        emit(state.copyWith(
          status: OrderPaymentStatus.fileSelected,
          selectedFile: File(picked.path),
          errorMessage: null,
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        status: OrderPaymentStatus.error,
        errorMessage: 'حدث خطأ أثناء اختيار الصورة، يرجى المحاولة مرة أخرى',
      ));
    }
  }

  Future<void> pickPdfReceipt() async {
    try {
      final pickedFile = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (pickedFile != null && pickedFile.path != null) {
        emit(state.copyWith(
          status: OrderPaymentStatus.fileSelected,
          selectedFile: File(pickedFile.path!),
          errorMessage: null,
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        status: OrderPaymentStatus.error,
        errorMessage: 'حدث خطأ أثناء اختيار ملف الـ PDF',
      ));
    }
  }

  void clearSelectedFile() {
    emit(state.copyWith(
      clearSelectedFile: true,
      status: OrderPaymentStatus.initial,
      errorMessage: null,
    ));
  }

  Future<bool> uploadReceipt({void Function(String receiptUrl)? onDone}) async {
    if (state.selectedFile == null) {
      emit(state.copyWith(
        status: OrderPaymentStatus.error,
        errorMessage: 'يرجى اختيار ملف أو صورة الإيصال أولاً',
      ));
      return false;
    }

    emit(state.copyWith(
      status: OrderPaymentStatus.uploadingReceipt,
      errorMessage: null,
    ));

    final result = await _orderRepository.uploadOrderReceipt(
      orderId: state.orderId,
      file: state.selectedFile!,
    );

    return result.when(
      success: (receiptUrl) {
        emit(state.copyWith(
          status: OrderPaymentStatus.uploadSuccess,
          uploadedReceiptUrl: receiptUrl,
          clearSelectedFile: true,
          successMessage: 'تم رفع إيصال التحويل بنجاح، وبانتظار مراجعة الإدارة المالية للمصنع',
        ));
        if (onDone != null) {
          onDone(receiptUrl);
        }
        return true;
      },
      failure: (error) {
        emit(state.copyWith(
          status: OrderPaymentStatus.error,
          errorMessage: error.message ?? 'فشل في رفع إيصال التحويل، يرجى إعادة المحاولة',
        ));
        return false;
      },
    );
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}
