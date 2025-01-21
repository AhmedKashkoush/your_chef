import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/common/blocs/cart/cart_bloc.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/core/widgets/counters/cart_item_counter.dart';
import 'package:your_chef/features/foods/domain/entities/cart_item.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/presentation/blocs/cart/add_remove/add_remove_cart_bloc.dart';
import 'package:your_chef/features/foods/presentation/blocs/cart/quantity/cart_quantity_bloc.dart';
import 'package:your_chef/locator.dart';

class AddToCartSection extends StatelessWidget {
  const AddToCartSection({
    super.key,
    required this.food,
  });

  final Food food;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocListener<AddRemoveCartBloc, AddRemoveCartState>(
          listener: (context, state) {
            if (state is AddToCartLoadingState) {
              AppMessages.showLoadingDialog(context,
                  message: AppStrings.justAMoment.tr());
            } else {
              AppMessages.dismissLoadingDialog(context);
              if (state is AddToCartFailureState) {
                AppMessages.showErrorMessage(
                    context, state.error, state.errorType);
              }
              if (state is AddToCartSuccessState) {
                final items = context.read<CartBloc>().state.items;
                final foodInCart = items.any((item) => item.food.id == food.id);
                if (foodInCart) {
                  items.removeWhere((item) => item.food.id == food.id);
                } else {
                  items.add(
                    CartItem(
                      id: food.id,
                      food: food,
                      quantity: 1,
                    ),
                  );
                }
                context.read<CartBloc>().add(UpdateCartEvent(items));
                AppMessages.showSuccessMessage(
                  context,
                  state.message,
                );
              }
            }
          },
          child: BlocBuilder<CartBloc, CartState>(
            // listenWhen: (previous, current) => previous.status != current.status,
            // listener: (context, state) {
            //   if (state.status == RequestStatus.loading) {
            //     AppMessages.showLoadingDialog(context,
            //         message: AppStrings.justAMoment.tr());
            //   } else {
            //     AppMessages.dismissLoadingDialog(context);
            //     if (state.status == RequestStatus.failure) {
            //       AppMessages.showErrorMessage(
            //           context, state.error, state.errorType);
            //     }
            //     if (state.status == RequestStatus.success &&
            //         state.message.isNotEmpty) {
            //       AppMessages.showSuccessMessage(
            //         context,
            //         state.message,
            //       );
            //     }
            //   }
            // },
            // buildWhen: (previous, current) => previous.items != current.items,
            builder: (context, state) {
              final index =
                  state.items.indexWhere((item) => item.food.id == food.id);

              if (index != -1) {
                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: BlocProvider(
                        create: (context) => locator<CartQuantityBloc>(),
                        child: CartItemCounter(item: state.items[index]),
                      ),
                    ),
                    // const Spacer(),
                    // Expanded(
                    //   child: SecondaryButton(
                    //     text: '',
                    //     icon: HugeIcons.strokeRoundedShoppingCartRemove01,
                    //     onPressed: () {
                    //       context.read<AddRemoveCartBloc>().add(
                    //             RemoveFromCartEvent(
                    //               food,
                    //             ),
                    //           );
                    //     },
                    //   ),
                    // ),
                    4.width,
                    // const Spacer(),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        text: AppStrings.viewInCart.tr(),
                        icon: HugeIcons.strokeRoundedShoppingCart01,
                        backgroundColor: Colors.green,
                        // count: state.items[index].quantity,
                        onPressed: () =>
                            context.pushReplacementNamed(AppRoutes.cart),
                      ),
                    ),
                  ],
                );
              }
              return PrimaryButton(
                text: AppStrings.addToCart.tr(),
                icon: HugeIcons.strokeRoundedShoppingCartAdd01,
                onPressed: () {
                  context.read<AddRemoveCartBloc>().add(
                        AddToCartEvent(
                          food,
                        ),
                      );
                },
              );
            },
          ),
        ));
  }
}
