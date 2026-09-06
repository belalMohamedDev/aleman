class UpdateCartItemRequestBody {
  final int quantity;

  const UpdateCartItemRequestBody({required this.quantity});

  Map<String, dynamic> toJson() => {'quantity': quantity};
}
