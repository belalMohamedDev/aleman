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
        final selectedPackageIndex = state.selectedPackageIndex;

        final hasPackages = product.packages.isNotEmpty;
        final currentPackage =
            (hasPackages && selectedPackageIndex < product.packages.length)
            ? product.packages[selectedPackageIndex]
            : (hasPackages ? product.packages.first : null);

        final displayPrice = currentPackage != null
            ? (isTonMode ? currentPackage.pricePerTon : currentPackage.price)
            : (isTonMode ? product.pricePerTon : product.price);

        final canToggleTon = currentPackage != null
            ? currentPackage.pricePerTon > 0
            : product.pricePerTon > 0;

        final currentWeight = currentPackage != null
            ? currentPackage.weightKg
            : product.weightPerSackKg;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeroSection(
                product: product,
                displayPrice: displayPrice,
                isTonMode: isTonMode,
                getGrowthStageName: _getGrowthStageName,
                getFeedFormName: _getFeedFormName,
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasPackages && product.packages.length > 1) ...[
                        _PackageSelector(
                          packages: product.packages,
                          selectedIndex: selectedPackageIndex,
                          isTonMode: isTonMode,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (canToggleTon) ...[
                        _UnitToggle(isTonMode: isTonMode),
                        const SizedBox(height: 16),
                      ],

                      if (product.description.isNotEmpty) ...[
                        const SizedBox(height: 18),
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
                        const SizedBox(height: 18),
                        _NutritionCard(product: product),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _ActionBar(
                product: product,
                currentPackage: currentPackage,
                currentWeight: currentWeight,
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
  const _HeroSection({
    required this.product,
    required this.displayPrice,
    required this.isTonMode,
    required this.getGrowthStageName,
    required this.getFeedFormName,
  });

  final ProductEntity product;
  final double displayPrice;
  final bool isTonMode;
  final String Function(int) getGrowthStageName;
  final String Function(int) getFeedFormName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: ColorManger.primaryLight.withValues(alpha: 0.06),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 4,
              width: 38,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 95.w,
                height: 95.w,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: CachedNetworkImage(
                  imageUrl: "${ApiConstants.baseUrl}${product.imageUrl}",
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.grass_rounded,
                    color: ColorManger.primaryLight.withValues(alpha: 0.4),
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5.sp,
                        color: ColorManger.primary,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${displayPrice.toStringAsFixed(0)} ج.م',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18.sp,
                            color: ColorManger.goldDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2.5,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManger.primaryLight.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isTonMode ? 'للطن' : 'للشكارة',
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              color: ColorManger.primaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    _SpecChipsRow(
                      product: product,
                      getGrowthStageName: getGrowthStageName,
                      getFeedFormName: getFeedFormName,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PackageSelector extends StatelessWidget {
  const _PackageSelector({
    required this.packages,
    required this.selectedIndex,
    required this.isTonMode,
  });

  final List<PackageEntity> packages;
  final int selectedIndex;
  final bool isTonMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Iconsax.box_1, size: 15, color: ColorManger.primary),
            const SizedBox(width: 6),
            Text(
              'حجم العبوة (الشكارة):',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5.sp,
                color: ColorManger.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(packages.length, (index) {
            final pkg = packages[index];
            final isSelected = selectedIndex == index;
            final isLast = index == packages.length - 1;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: isLast ? 0 : 8.0),
                child: GestureDetector(
                  onTap: () =>
                      context.read<HomeCuibtCubit>().selectPackage(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorManger.primaryLight.withValues(alpha: 0.2)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? ColorManger.primaryLight.withValues(alpha: 0.1)
                            : Colors.grey.shade200,
                        width: isSelected ? 1.6 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.weight,
                              size: 13,
                              color: isSelected
                                  ? ColorManger.primaryLight
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${pkg.weightKg.toStringAsFixed(0)} كجم',
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                fontSize: 12.sp,
                                color: isSelected
                                    ? ColorManger.primary
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isTonMode
                              ? '${pkg.pricePerTon.toStringAsFixed(0)} ج.م/طن'
                              : '${pkg.price.toStringAsFixed(0)} ج.م',
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? ColorManger.primary
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _UnitToggle extends StatelessWidget {
  const _UnitToggle({required this.isTonMode});
  final bool isTonMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3.5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 240),
                curve: Curves.fastOutSlowIn,
                alignment: isTonMode
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: Container(
                  width: itemWidth,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _ToggleOption(
                      label: 'بالشكارة',
                      icon: Iconsax.box,
                      isSelected: !isTonMode,
                      onTap: () =>
                          context.read<HomeCuibtCubit>().toggleTonMode(false),
                    ),
                  ),
                  Expanded(
                    child: _ToggleOption(
                      label: 'بالطن',
                      icon: Iconsax.truck,
                      isSelected: isTonMode,
                      onTap: () =>
                          context.read<HomeCuibtCubit>().toggleTonMode(true),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: 15,
                color: isSelected
                    ? ColorManger.primaryLight
                    : Colors.grey.shade500,
              ),
            ),
            const SizedBox(width: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? ColorManger.primaryLight
                    : Colors.grey.shade500,
              ),
              child: Text(label),
            ),
          ],
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
    final chips =
        <({String label, IconData icon, Color color, Color bg, Color border})>[
          if (product.proteinPercentage > 0)
            (
              label: '${product.proteinPercentage.toStringAsFixed(0)}% بروتين',
              icon: Iconsax.health,
              color: ColorManger.chipProtein,
              bg: ColorManger.chipProteinBg.withValues(alpha: .3),
              border: ColorManger.chipProteinBorder.withValues(alpha: .3),
            ),
          if (product.growthStage > 0)
            (
              label: getGrowthStageName(product.growthStage),
              icon: Iconsax.trend_up,
              color: ColorManger.chipStage,
              bg: ColorManger.chipStageBg.withValues(alpha: .3),
              border: ColorManger.chipStageBorder.withValues(alpha: .3),
            ),
          if (product.feedForm > 0)
            (
              label: getFeedFormName(product.feedForm),
              icon: Iconsax.element_4,
              color: ColorManger.primaryLight,
              bg: ColorManger.chipFormBg.withValues(alpha: .3),
              border: ColorManger.chipFormBorder.withValues(alpha: .3),
            ),
        ];
    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 5,
      children: chips
          .map(
            (c) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
              decoration: BoxDecoration(
                color: c.bg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: c.border, width: 0.9),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(c.icon, size: 12, color: c.color),
                  const SizedBox(width: 4),
                  Text(
                    c.label,
                    style: TextStyle(
                      fontSize: 10.5.sp,
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
    required this.currentPackage,
    required this.currentWeight,
    required this.quantity,
    required this.isTonMode,
    required this.responsive,
  });

  final ProductEntity product;
  final PackageEntity? currentPackage;
  final double currentWeight;
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
                  final unitLabel = isTonMode
                      ? 'طن'
                      : 'شكارة (${currentWeight > 0 ? currentWeight.toStringAsFixed(0) : ''} كجم)';
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
          color: filled ? ColorManger.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled
              ? Colors.white
              : (enabled ? ColorManger.primaryLight : Colors.grey.shade400),
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
  late FocusNode _focusNode;

  String _fmt(double val) =>
      val == val.truncateToDouble() ? '${val.toInt()}' : val.toStringAsFixed(1);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _fmt(widget.initialValue));
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
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
  void didUpdateWidget(_QuantityInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      final parsed = double.tryParse(_controller.text);
      if (parsed != widget.initialValue) {
        _controller.text = _fmt(widget.initialValue);
      }
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
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: ColorManger.primary,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        filled: false,
        fillColor: Colors.transparent,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      onSubmitted: (val) {
        final parsed = double.tryParse(val);
        if (parsed != null && parsed > 0) {
          context.read<HomeCuibtCubit>().setQuantity(
            widget.isTonMode ? parsed : parsed.truncateToDouble(),
          );
        }
      },
    );
  }
}
