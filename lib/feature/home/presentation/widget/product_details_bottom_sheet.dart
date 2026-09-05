import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/home/data/mapper/product_mapper.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsBottomSheet extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Image
            Center(
              child: Container(
                height: responsive.setHeight(20),
                width: responsive.setWidth(50),
                decoration: BoxDecoration(
                  color: ColorManger.primaryLight.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: CachedNetworkImage(
                  imageUrl: "${ApiConstants.baseUrl}${product.imageUrl}",
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title and Price Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: responsive.setTextSize(4.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${product.price} ج.م',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorManger.goldDark,
                      fontSize: responsive.setTextSize(4.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                product.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                  fontSize: responsive.setTextSize(3.5),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),

            // Counter & Add to cart button
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
              child: Row(
                children: [
                  // Counter
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
                      buildWhen: (previous, current) =>
                          previous.quantity != current.quantity,
                      builder: (context, state) {
                        final quantity = state.quantity;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Plus button
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<HomeCuibtCubit>()
                                    .incrementQuantity();
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorManger.primaryLight,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManger.primaryLight
                                          .withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Iconsax.add,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            // Number (Editable)
                            SizedBox(
                              width:
                                  60, // Made wider for large numbers like 1000
                              child: Center(
                                child: _QuantityInputField(
                                  initialValue: quantity,
                                ),
                              ),
                            ),

                            // Minus button
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<HomeCuibtCubit>()
                                    .decrementQuantity();
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: quantity > 1
                                      ? Colors.white
                                      : Colors.transparent,
                                  boxShadow: quantity > 1
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Icon(
                                  Iconsax.minus,
                                  size: 20,
                                  color: quantity > 1
                                      ? Colors.black87
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Button
                  Expanded(
                    child: BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
                      buildWhen: (previous, current) =>
                          previous.quantity != current.quantity,
                      builder: (context, state) {
                        return SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تمت إضافة ${state.quantity} من ${product.name} إلى السلة',
                                  ),
                                  backgroundColor: ColorManger.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManger.primaryLight,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: ColorManger.primary.withValues(
                                alpha: 0.4,
                              ),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Iconsax.bag_happy, size: 22),
                                const SizedBox(width: 8),
                                Text(
                                  'أضف للسلة',
                                  style: TextStyle(
                                    fontSize: responsive.setTextSize(4.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityInputField extends StatefulWidget {
  final int initialValue;

  const _QuantityInputField({required this.initialValue});

  @override
  State<_QuantityInputField> createState() => _QuantityInputFieldState();
}

class _QuantityInputFieldState extends State<_QuantityInputField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());

    // Select all text when focused for quick typing
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      } else {
        // If user leaves it empty or invalid, reset to current cubit state
        if (_controller.text.isEmpty ||
            int.tryParse(_controller.text) == null ||
            int.parse(_controller.text) <= 0) {
          final currentQuantity = context.read<HomeCuibtCubit>().state.quantity;
          _controller.text = currentQuantity.toString();
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant _QuantityInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && !_focusNode.hasFocus) {
      _controller.text = widget.initialValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black87,
      ),
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: (value) {
        final parsed = int.tryParse(value);
        if (parsed != null && parsed > 0) {
          context.read<HomeCuibtCubit>().setQuantity(parsed);
        }
      },
    );
  }
}
