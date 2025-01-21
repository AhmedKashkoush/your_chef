import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/common/blocs/cart/cart_bloc.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';

class CartButton extends StatelessWidget {
  final IconData icon;
  const CartButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Badge.count(
          count: state.items.length,
          isLabelVisible: state.items.isNotEmpty,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          padding: const EdgeInsets.all(2).r,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          child: FloatingActionButton(
            onPressed: () => context.pushNamed(AppRoutes.cart),
            backgroundColor: AppColors.primary,
            child: Icon(icon, color: Colors.white),
          ),
        );
      },
    );
  }
}
