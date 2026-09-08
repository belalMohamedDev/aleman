class OrderResponseModel {
  final String id;
  final String orderNumber;
  final int orderType;
  final String orderTypeName;
  final double subTotal;
  final double shippingFee;
  final double discount;
  final double total;
  final int paymentMethod;
  final String paymentMethodName;
  final String status;
  final double totalWeightTons;
  final int totalItemsCount;
  final DateTime? createdAt;

  const OrderResponseModel({
    required this.id,
    required this.orderNumber,
    required this.orderType,
    this.orderTypeName = '',
    required this.subTotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    this.paymentMethodName = '',
    required this.status,
    this.totalWeightTons = 0.0,
    this.totalItemsCount = 0,
    this.createdAt,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderResponseModel(
        id: json['id']?.toString() ?? '',
        orderNumber: json['orderNumber'] as String? ?? '',
        orderType: (json['orderType'] as num?)?.toInt() ?? 1,
        orderTypeName: json['orderTypeName'] as String? ?? '',
        subTotal: (json['subtotal'] as num?)?.toDouble() ??
            (json['subTotal'] as num?)?.toDouble() ??
            0.0,
        shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
        discount: (json['discountAmount'] as num?)?.toDouble() ??
            (json['discount'] as num?)?.toDouble() ??
            0.0,
        total: (json['totalAmount'] as num?)?.toDouble() ??
            (json['total'] as num?)?.toDouble() ??
            0.0,
        paymentMethod: (json['paymentMethod'] as num?)?.toInt() ?? 1,
        paymentMethodName: json['paymentMethodName'] as String? ?? '',
        status: json['statusName'] as String? ??
            (json['status'] is int
                ? json['status'].toString()
                : json['status'] as String? ?? 'قيد الانتظار'),
        totalWeightTons:
            (json['totalWeightTons'] as num?)?.toDouble() ?? 0.0,
        totalItemsCount: (json['totalItemsCount'] as num?)?.toInt() ?? 0,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );
}
