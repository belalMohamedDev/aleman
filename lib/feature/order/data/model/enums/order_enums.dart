enum OrderType {
  delivery(1, 'وصال (توصيل المصنع)', 'المصنع يتولى شحن وتوصيل الطلب إلى عنوانك'),
  factoryPickup(2, 'استلام أرض المصنع', 'تقوم بإرسال سياراتك للتحميل مباشرة من أرض المصنع');

  final int value;
  final String title;
  final String description;

  const OrderType(this.value, this.title, this.description);
}

enum TruckType {
  dababa(1, 'دبابة', 'شاحنة خفيفة (حمولة حتى 2 طن)', 2.0),
  jumbo(2, 'جامبو', 'شاحنة متوسطة (حمولة حتى 7 طن)', 7.0),
  trella(3, 'تريلا', 'شاحنة ثقيلة (حمولة حتى 25 طن)', 25.0);

  final int value;
  final String title;
  final String description;
  final double maxCapacityTons;

  const TruckType(this.value, this.title, this.description, this.maxCapacityTons);

  static TruckType fromWeight(double weightInTons) {
    if (weightInTons <= 2.0) {
      return TruckType.dababa;
    } else if (weightInTons <= 7.0) {
      return TruckType.jumbo;
    } else {
      return TruckType.trella;
    }
  }
}

enum PaymentMethodType {
  cashOnDelivery(1, 'الدفع عند الاستلام / التحميل'),
  card(2, 'بطاقة ائتمان أو خصم مباشر');

  final int value;
  final String title;

  const PaymentMethodType(this.value, this.title);
}
