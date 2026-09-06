import 'package:aleman/core/style/color/color_manger.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_cubit.dart';
import 'package:aleman/feature/cart/logic/cubit/cart_state.dart';
import 'package:aleman/feature/cart/presentation/refactor/cart_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (prev, curr) =>
          prev.cart?.items.isEmpty != curr.cart?.items.isEmpty,
      builder: (context, state) {
        final isEmpty = state.cart == null || state.cart!.items.isEmpty;

        return Scaffold(
          appBar: AppBar(
            title: isEmpty
                ? null
                : Text(
                    'سلتي',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: ColorManger.primary),
            actions: isEmpty
                ? null
                : [
                    IconButton(
                      onPressed: () {
                        context.read<CartCubit>().clearCart();
                      },
                      icon: Icon(Icons.delete, color: ColorManger.primaryLight),
                      tooltip: 'حذف السلة',
                    ),
                    const SizedBox(width: 8),
                  ],
          ),
          body: const CartBody(),
        );
      },
    );
  }
}
