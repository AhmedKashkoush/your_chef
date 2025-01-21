import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/common/blocs/cart/cart_bloc.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/widgets/buttons/custom_icon_button.dart';
import 'package:your_chef/features/foods/domain/entities/cart_item.dart';
import 'package:your_chef/features/foods/presentation/blocs/cart/quantity/cart_quantity_bloc.dart';

class CartItemCounter extends StatefulWidget {
  final CartItem item;
  const CartItemCounter({super.key, required this.item});

  @override
  State<CartItemCounter> createState() => _CartItemCounterState();
}

class _CartItemCounterState extends State<CartItemCounter> {
  late int _counter = widget.item.quantity;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _increment(BuildContext context) {
    _debounce?.cancel();

    setState(() {
      _counter++;
    });
    _debounce = Timer(const Duration(seconds: 1), () {
      context.read<CartQuantityBloc>().add(
            IncrementCartQuantityEvent(
              CartItem(
                id: widget.item.id,
                food: widget.item.food,
                quantity: _counter,
              ),
            ),
          );
    });
  }

  void _decrement(BuildContext context) {
    if (_counter == 1) return;
    setState(() {
      _counter--;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      context.read<CartQuantityBloc>().add(
            DecrementCartQuantityEvent(
              CartItem(
                id: widget.item.id,
                food: widget.item.food,
                quantity: _counter,
              ),
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomIconButton(
          onPressed: () => _decrement(context),
          icon: const Icon(Icons.remove),
          backgroundColor: context.theme.iconTheme.color?.withOpacity(0.2),
        ),
        // 10.width,
        BlocConsumer<CartQuantityBloc, CartQuantityState>(
          listener: (context, state) {
            if (state is CartQuantityLoadingState) {
              AppMessages.showLoadingDialog(
                context,
                message: AppStrings.justAMoment.tr(),
              );
            } else {
              AppMessages.dismissLoadingDialog(context);
              if (state is CartQuantityFailureState) {
                AppMessages.showErrorMessage(
                    context, state.error, state.errorType);
                _counter = widget.item.quantity;
              }
              if (state is CartQuantitySuccessState) {
                final items = context.read<CartBloc>().state.items;
                final index = items.indexWhere(
                  (cartItem) => cartItem.food.id == widget.item.food.id,
                );
                items[index] = items[index].copyWith(
                  quantity: _counter,
                );
                context.read<CartBloc>().add(
                      UpdateCartEvent(items),
                    );
                AppMessages.showSuccessMessage(
                  context,
                  state.message,
                );
              }
            }
          },
          builder: (context, state) {
            return SizedBox(
              width: 24.w,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(4).r,
                  child: Center(
                    child: Text(
                      _counter.toString(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // 10.width,
        CustomIconButton(
          onPressed: () => _increment(context),
          icon: const Icon(Icons.add),
          backgroundColor: context.theme.iconTheme.color?.withOpacity(0.2),
        ),
      ],
    );
  }
}
