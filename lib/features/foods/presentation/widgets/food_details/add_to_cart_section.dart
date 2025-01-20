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
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/core/widgets/buttons/secondary_button.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';

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
        child: BlocConsumer<CartBloc, CartState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == RequestStatus.loading) {
              AppMessages.showLoadingDialog(context,
                  message: AppStrings.justAMoment.tr());
            } else {
              AppMessages.dismissLoadingDialog(context);
              if (state.status == RequestStatus.failure) {
                AppMessages.showErrorMessage(
                    context, state.error, state.errorType);
              }
              if (state.status == RequestStatus.success &&
                  state.message.isNotEmpty) {
                AppMessages.showSuccessMessage(
                  context,
                  state.message,
                );
              }
            }
          },
          buildWhen: (previous, current) => previous.items != current.items,
          builder: (context, state) {
            final inCart = state.items.any((item) => item.food.id == food.id);
            if (inCart) {
              return Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: AppStrings.removeFromCart.tr(),
                      icon: HugeIcons.strokeRoundedShoppingCartRemove01,
                      onPressed: () {
                        context.read<CartBloc>().add(
                              RemoveFoodFromCartEvent(
                                food,
                              ),
                            );
                      },
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: PrimaryButton(
                      text: AppStrings.viewInCart.tr(),
                      icon: HugeIcons.strokeRoundedShoppingCart01,
                      backgroundColor: Colors.green,
                      count: state.items
                          .where((item) => item.food.id == food.id)
                          .first
                          .quantity,
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
                context.read<CartBloc>().add(
                      AddFoodToCartEvent(
                        food,
                      ),
                    );
              },
            );
          },
        ));
  }
}
