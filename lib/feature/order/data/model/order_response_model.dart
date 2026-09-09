class OrderItemModel {
  final int id;
  final String productName;
  final String? productImage;
  final double weightKg;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const OrderItemModel({
    required this.id,
    required this.productName,
    this.productImage,
    required this.weightKg,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
    id: (json['id'] as num?)?.toInt() ?? 0,
    productName:
        json['productName'] as String? ??
        json['name'] as String? ??
        'علف آل إيمان',
    productImage:
        json['productImage'] as String? ?? json['imageUrl'] as String?,
    weightKg: (json['weightKg'] as num?)?.toDouble() ?? 50.0,
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    unitPrice:
        (json['unitPrice'] as num?)?.toDouble() ??
        (json['price'] as num?)?.toDouble() ??
        0.0,
    totalPrice:
        (json['totalPrice'] as num?)?.toDouble() ??
        (json['total'] as num?)?.toDouble() ??
        0.0,
  );
}

class OrderResponseModel {
  final String id;
  final String orderNumber;
  final int orderType; // 1: وصال, 2: أرض المصنع
  final String orderTypeName;
  final double subTotal;
  final double shippingFee;
  final double discount;
  final double total;
  final int paymentMethod;
  final String paymentMethodName;
  final int statusCode; // 1: Pending, 2: Confirmed, 3: Preparing, 4: OutForDelivery, 5: ReadyForPickup, 6: Completed, 7: Cancelled
  final String status;
  final double totalWeightTons;
  final int totalItemsCount;
  final DateTime? createdAt;

  // تفاصيل إضافية للشاحنة والسائق والاستلام
  final String? truckName;
  final String? driverName;
  final String? vehiclePlateNumber;
  final String? driverLicenseNumber;
  final DateTime? expectedPickupDate;
  final String? customerName;
  final String? userId;
  final String? addressText;
  final String? notes;
  final List<OrderItemModel> items;

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
    this.statusCode = 1,
    required this.status,
    this.totalWeightTons = 0.0,
    this.totalItemsCount = 0,
    this.createdAt,
    this.truckName,
    this.driverName,
    this.vehiclePlateNumber,
    this.driverLicenseNumber,
    this.expectedPickupDate,
    this.customerName,
    this.userId,
    this.addressText,
    this.notes,
    this.items = const [],
  });

  factory OrderResponseModel.fromId(String id) => OrderResponseModel(
    id: id,
    orderNumber: id,
    orderType: 1,
    subTotal: 0,
    shippingFee: 0,
    discount: 0,
    total: 0,
    paymentMethod: 1,
    status: '',
  );

  bool get isWesal => orderType == 1;
  bool get isFactoryPickup => orderType == 2;
  bool get isPending => statusCode == 1;
  bool get isConfirmed => statusCode == 2;
  bool get isPreparing => statusCode == 3;
  bool get isOutForDelivery => statusCode == 4;
  bool get isReadyForPickup => statusCode == 5;
  bool get isCompleted => statusCode == 6;
  bool get isCancelled => statusCode == 7;
  bool get isActive => statusCode >= 1 && statusCode <= 5;

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    int parsedStatusCode = 1;
    if (json['statusCode'] is int) {
      parsedStatusCode = json['statusCode'] as int;
    } else if (json['status'] is int) {
      parsedStatusCode = json['status'] as int;
    }

    String statusText = 'قيد الانتظار';
    if (json['statusName'] is String &&
        (json['statusName'] as String).isNotEmpty) {
      statusText = json['statusName'] as String;
    } else {
      switch (parsedStatusCode) {
        case 1:
          statusText = 'قيد الانتظار';
          break;
        case 2:
          statusText = 'تم التأكيد';
          break;
        case 3:
          statusText = 'قيد التجهيز';
          break;
        case 4:
          statusText = 'خرج للتوصيل';
          break;
        case 5:
          statusText = 'جاهز للتحميل';
          break;
        case 6:
          statusText = 'مكتمل';
          break;
        case 7:
          statusText = 'ملغي';
          break;
        default:
          statusText = 'قيد الانتظار';
      }
    }

    List<OrderItemModel> parsedItems = [];
    if (json['items'] is List) {
      parsedItems = (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    String? cleanStr(dynamic val) {
      if (val is! String) return null;
      final trimmed = val.trim();
      if (trimmed.isEmpty || trimmed.toLowerCase() == 'string') return null;
      return trimmed;
    }

    final rawOrderNumber = cleanStr(json['orderNumber']);
    final rawId = json['id']?.toString() ?? '';
    final orderNumber =
        rawOrderNumber ?? (rawId.isNotEmpty && rawId != '0' ? rawId : '1001');

    final rawTypeName = cleanStr(json['orderTypeName']);
    final orderTypeName =
        rawTypeName ?? ((json['orderType'] == 2) ? 'أرض المصنع' : 'وصال');

    final rawPayName = cleanStr(json['paymentMethodName']);
    final paymentMethodName =
        rawPayName ??
        ((json['paymentMethod'] == 2) ? 'بطاقة دفع' : 'كاش عند الاستلام');

    String? addressText;
    if (json['deliveryAddress'] is Map) {
      final addr = json['deliveryAddress'] as Map;
      final parts = [
        cleanStr(addr['city']),
        cleanStr(addr['district']),
        cleanStr(addr['street']),
      ].whereType<String>().toList();
      if (parts.isNotEmpty) {
        addressText = parts.join(' - ');
      }
    } else if (json['address'] is Map) {
      addressText = cleanStr(json['address']['street']);
    } else {
      addressText = cleanStr(json['addressText']);
    }

    return OrderResponseModel(
      id: rawId,
      orderNumber: orderNumber,
      orderType: (json['orderType'] as num?)?.toInt() ?? 1,
      orderTypeName: orderTypeName,
      subTotal:
          (json['subtotal'] as num?)?.toDouble() ??
          (json['subTotal'] as num?)?.toDouble() ??
          0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      discount:
          (json['discountAmount'] as num?)?.toDouble() ??
          (json['discount'] as num?)?.toDouble() ??
          0.0,
      total:
          (json['totalAmount'] as num?)?.toDouble() ??
          (json['total'] as num?)?.toDouble() ??
          0.0,
      paymentMethod: (json['paymentMethod'] as num?)?.toInt() ?? 1,
      paymentMethodName: paymentMethodName,
      statusCode: parsedStatusCode,
      status: statusText,
      totalWeightTons: (json['totalWeightTons'] as num?)?.toDouble() ?? 0.0,
      totalItemsCount:
          (json['totalItemsCount'] as num?)?.toInt() ?? parsedItems.length,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      truckName: cleanStr(json['truckName']),
      driverName: cleanStr(json['driverName']),
      vehiclePlateNumber: cleanStr(json['vehiclePlateNumber']),
      driverLicenseNumber: cleanStr(json['driverLicenseNumber']),
      expectedPickupDate: json['expectedPickupDate'] != null
          ? DateTime.tryParse(json['expectedPickupDate'] as String)
          : null,
      customerName: cleanStr(json['customerName']),
      userId: cleanStr(json['userId']?.toString()),
      addressText: addressText,
      notes: cleanStr(json['notes']),
      items: parsedItems,
    );
  }
}
