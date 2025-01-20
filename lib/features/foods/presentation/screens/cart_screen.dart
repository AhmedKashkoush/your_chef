import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/common/blocs/cart/cart_bloc.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/widgets/buttons/custom_icon_button.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/core/widgets/rating/star_rating_widget.dart';
import 'package:your_chef/features/foods/domain/entities/cart_item.dart';

part '../widgets/cart/cart_calculations_widget.dart';
part '../widgets/cart/empty_cart_widget.dart';
part '../widgets/cart/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              HugeIcons.strokeRoundedShoppingCart01,
            ),
            10.width,
            Text(
              AppStrings.yourCart.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: context.theme.colorScheme.surface,
      body: BlocConsumer<CartBloc, CartState>(
        listenWhen: (previous, current) =>
            previous.status != current.status && current.message.isNotEmpty,
        listener: (context, state) {
          if (state.status == RequestStatus.success) {
            if (state.message.isNotEmpty) {
              AppMessages.showSuccessMessage(context, state.message);
            }
          }
        },
        builder: (context, state) {
          if (state.items.isEmpty) {
            if (state.status == RequestStatus.loading) {
              return _buildList(
                items: _loadingList,
                loading: true,
              );
            }
            if (state.status == RequestStatus.failure) {
              return CustomErrorWidget(
                  error: state.error,
                  type: state.errorType,
                  onRetry: () {
                    context.read<CartBloc>().add(GetCartEvent());
                  });
            }
            if (state.status == RequestStatus.success) {
              return const EmptyCartWidget();
            }
          }
          if (state.status == RequestStatus.initial) {
            return const SizedBox.shrink();
          }
          return _buildList(items: state.items, loading: false);
        },
      ),
      extendBody: true,
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          buildWhen: (previous, current) => previous.total != current.total,
          builder: (context, state) {
            if (state.items.isNotEmpty &&
                state.status == RequestStatus.success) {
              return Container(
                color: context.theme.scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0).r,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CartCalculationsWidget(
                          label: 'Subtotal',
                          fontSize: 14.sp,
                          price: state.total,
                        ),
                        10.height,
                        CartCalculationsWidget(
                          label: 'Fees',
                          fontSize: 14.sp,
                          price: state.fees,
                        ),
                        10.height,
                        CartCalculationsWidget(
                          label: 'Total',
                          fontSize: 18.sp,
                          price: state.total + state.fees,
                        ),
                        10.height,
                        PrimaryButton(
                          text:
                              'Checkout ${(state.total + state.fees).toStringAsFixed(2)} ${AppStrings.egp.tr()}',
                          onPressed: () {},
                        ),
                      ]),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
    );
  }

  List<CartItem> get _loadingList => List.generate(
        10,
        (index) => CartItem(
          id: index,
          quantity: 1,
          food: AppDummies.foods.first.toEntity(),
        ),
      );

  Widget _buildList({required List<CartItem> items, required bool loading}) {
    return SkeletonLoadingWidget(
      loading: loading,
      child: ListView.separated(
        itemBuilder: (_, index) => CartItemCard(
          item: items[index],
          tag: 'cart',
        ),
        separatorBuilder: (_, index) => 8.height,
        itemCount: items.length,
      ),
    );
  }
}
