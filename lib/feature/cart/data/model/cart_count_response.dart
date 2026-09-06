class CartCountResponse {
  final int count;

  const CartCountResponse({required this.count});

  factory CartCountResponse.fromJson(Map<String, dynamic> json) =>
      CartCountResponse(
        count: (json['count'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'count': count,
      };
}
