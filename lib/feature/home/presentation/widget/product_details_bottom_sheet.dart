import 'package:aleman/core/network/api_constant/api_constant.dart';
import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/core/utils/responsive_utils.dart';
import 'package:aleman/feature/home/data/mapper/product_mapper.dart';
import 'package:aleman/feature/home/logic/cubit/home_cuibt_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsBottomSheet extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsBottomSheet({super.key, required this.product});

  String _getGrowthStageName(int stage) {
    switch (stage) {
      case 1:
        return 'بادي';
      case 2:
        return 'نامي';
      case 3:
        return 'ناهي';
      case 4:
        return 'بياض';
      default:
        return 'غير محدد';
    }
  }

  String _getFeedFormName(int form) {
    switch (form) {
      case 1:
        return 'محبب';
      case 2:
        return 'ناعم';
      case 3:
        return 'مفتت';
      default:
        return 'غير محدد';
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return BlocBuilder<HomeCuibtCubit, HomeCuibtState>(
      builder: (context, state) {
        final isTonMode = state.isTonMode;
        final quantity = state.quantity;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeroSection(product: product, isTonMode: isTonMode),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.pricePerTon > 0) ...[
                        _UnitToggle(isTonMode: isTonMode),
                        const SizedBox(height: 20),
                      ],
                      _SpecChipsRow(
                        product: product,
                        getGrowthStageName: _getGrowthStageName,
                        getFeedFormName: _getFeedFormName,
                      ),
                      if (product.description.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(
                          product.description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13.sp,
                            height: 1.6,
                          ),
                        ),
                      ],
                      if (product.ingredients.isNotEmpty ||
                          product.additives.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _NutritionCard(product: product),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _ActionBar(
                product: product,
                quantity: quantity,
                isTonMode: isTonMode,
                responsive: responsive,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.product, required this.isTonMode});
  final ProductEntity product;
  final bool isTonMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManger.primaryLight.withValues(alpha: 0.06),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              height: 4,
              width: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 5,
            child: CachedNetworkImage(
              imageUrl: "${ApiConstants.baseUrl}${product.imageUrl}",
              height: 190.h,
              fit: BoxFit.contain,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade50,
                child: Container(
                  height: 140.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.grass_rounded,
                color: ColorManger.primaryLight.withValues(alpha: 0.4),
                size: 64,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    ColorManger.primaryLight.withValues(alpha: 0.08),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: ColorManger.primary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isTonMode
                            ? '${product.pricePerTon} ج.م'
                            : '${product.price} ج.م',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18.sp,
                          color: ColorManger.goldDark,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        isTonMode ? 'للطن' : 'للشكارة',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitToggle extends StatelessWidget {
  const _UnitToggle({required this.isTonMode});
  final bool isTonMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          _ToggleOption(
            label: 'بالشكارة',
            icon: Iconsax.box,
            isSelected: !isTonMode,
            onTap: () => context.read<HomeCuibtCubit>().toggleTonMode(false),
          ),
          _ToggleOption(
            label: 'بالطن',
            icon: Iconsax.truck,
            isSelected: isTonMode,
            onTap: () => context.read<HomeCuibtCubit>().toggleTonMode(true),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected
                    ? ColorManger.primaryLight
                    : Colors.grey.shade500,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? ColorManger.primaryLight
                      : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecChipsRow extends StatelessWidget {
  const _SpecChipsRow({
    required this.product,
    required this.getGrowthStageName,
    required this.getFeedFormName,
  });
  final ProductEntity product;
  final String Function(int) getGrowthStageName;
  final String Function(int) getFeedFormName;

  @override
  Widget build(BuildContext context) {
    final chips = <({String label, IconData icon, Color color})>[
      if (product.proteinPercentage > 0)
        (
          label: '${product.proteinPercentage.toStringAsFixed(0)}% بروتين',
          icon: Iconsax.health,
          color: const Color(0xFFE53935),
        ),
      if (product.growthStage > 0)
        (
          label: getGrowthStageName(product.growthStage),
          icon: Iconsax.trend_up,
          color: const Color(0xFF1E88E5),
        ),
      if (product.feedForm > 0)
        (
          label: getFeedFormName(product.feedForm),
          icon: Iconsax.element_4,
          color: const Color(0xFF43A047),
        ),
      if (product.weightPerSackKg > 0)
        (
          label: '${product.weightPerSackKg.toStringAsFixed(0)} كجم',
          icon: Iconsax.weight,
          color: const Color(0xFFF57C00),
        ),
    ];
    if (chips.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips
          .map(
            (c) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: c.color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: c.color.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(c.icon, size: 13, color: c.color),
                  const SizedBox(width: 5),
                  Text(
                    c.label,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: c.color,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  Iconsax.info_circle,
                  size: 16,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'المعلومات الغذائية',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          if (product.ingredients.isNotEmpty) ...[
            const SizedBox(height: 10),
            _nutRow('المكونات', product.ingredients),
          ],
          if (product.additives.isNotEmpty) ...[
            const SizedBox(height: 8),
            _nutRow('الإضافات', product.additives),
          ],
        ],
      ),
    );
  }

  Widget _nutRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade300,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.product,
    required this.quantity,
    required this.isTonMode,
    required this.responsive,
  });
  final ProductEntity product;
  final double quantity;
  final bool isTonMode;
  final ResponsiveUtils responsive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CounterBtn(
                  icon: Iconsax.minus,
                  onTap: () =>
                      context.read<HomeCuibtCubit>().decrementQuantity(),
                  enabled: quantity > (isTonMode ? 0.5 : 1),
                ),
                SizedBox(
                  width: 56,
                  child: Center(
                    child: _QuantityInputField(
                      initialValue: quantity,
                      isTonMode: isTonMode,
                    ),
                  ),
                ),
                _CounterBtn(
                  icon: Iconsax.add,
                  onTap: () =>
                      context.read<HomeCuibtCubit>().incrementQuantity(),
                  enabled: true,
                  filled: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  final unitLabel = isTonMode ? 'طن' : 'شكارة';
                  final qtyLabel = quantity == quantity.truncateToDouble()
                      ? quantity.toInt().toString()
                      : quantity.toStringAsFixed(1);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تمت إضافة $qtyLabel $unitLabel من ${product.name} للسلة',
                      ),
                      backgroundColor: ColorManger.primaryLight,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(12),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Iconsax.bag_happy, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'أضف للسلة',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  const _CounterBtn({
    required this.icon,
    required this.onTap,
    required this.enabled,
    this.filled = false,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: filled
              ? ColorManger.primaryLight
              : (enabled ? Colors.white : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
          boxShadow: (enabled && !filled)
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 18,
          color: filled
              ? Colors.white
              : (enabled ? Colors.black87 : Colors.grey.shade400),
        ),
      ),
    );
  }
}

class _QuantityInputField extends StatefulWidget {
  final double initialValue;
  final bool isTonMode;
  const _QuantityInputField({
    required this.initialValue,
    required this.isTonMode,
  });

  @override
  State<_QuantityInputField> createState() => _QuantityInputFieldState();
}

class _QuantityInputFieldState extends State<_QuantityInputField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  String _fmt(double val) => val == val.truncateToDouble()
      ? val.toInt().toString()
      : val.toStringAsFixed(1);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _fmt(widget.initialValue));
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      } else {
        final parsed = double.tryParse(_controller.text);
        if (parsed == null || parsed <= 0) {
          _controller.text = _fmt(
            context.read<HomeCuibtCubit>().state.quantity,
          );
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant _QuantityInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && !_focusNode.hasFocus) {
      _controller.text = _fmt(widget.initialValue);
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
      keyboardType: widget.isTonMode
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16,
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
        final parsed = double.tryParse(value);
        if (parsed != null && parsed > 0) {
          context.read<HomeCuibtCubit>().setQuantity(
            widget.isTonMode ? parsed : parsed.truncateToDouble(),
          );
        }
      },
    );
  }
}
