part of '../../screens/cart_screen.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final String tag;
  const CartItemCard({
    super.key,
    required this.item,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(item.id),
      color: context.theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0).r,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: item.food.images.first,
                  placeholder: (_, __) => const SkeletonLoadingWidget(
                    child: SizedBox(),
                  ),
                ),
              ),
            ),
            10.width,
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.food.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  2.height,
                  Text.rich(
                    TextSpan(
                      children: [
                        if (item.food.rate > 0) ...[
                          WidgetSpan(
                            child: StarRatingWidget(
                              rate: item.food.rate.toDouble(),
                              size: 14,
                            ),
                          ),
                          TextSpan(
                            text: ' (${item.food.rate})',
                          ),
                        ] else
                          TextSpan(
                            text: AppStrings.noRatings.tr(),
                          )
                      ],
                      style: TextStyle(
                        color: context.theme.iconTheme.color?.withOpacity(0.6),
                      ),
                    ),
                  ),
                  10.height,
                  if (item.food.sale > 0.0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${(item.food.price - (item.food.price * item.food.sale)).toStringAsFixed(1)} ${AppStrings.egp.tr()}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.primary.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        5.width,
                        Transform.translate(
                          offset: const Offset(0, 4),
                          child: Text(
                            '${item.food.price} ${AppStrings.egp.tr()}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 0.8,
                              color: context.theme.iconTheme.color
                                  ?.withOpacity(0.5),
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: context.theme.iconTheme.color
                                  ?.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      '${item.food.price.asThousands} ${AppStrings.egp.tr()}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.primary.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocProvider(
                  create: (context) => locator<AddRemoveCartBloc>(),
                  child: Builder(builder: (context) {
                    return BlocListener<AddRemoveCartBloc, AddRemoveCartState>(
                      listener: (context, state) {
                        if (state is AddToCartLoadingState) {
                          AppMessages.showLoadingDialog(
                            context,
                            message: AppStrings.justAMoment.tr(),
                          );
                        } else {
                          AppMessages.dismissLoadingDialog(context);
                          if (state is AddToCartFailureState) {
                            AppMessages.showErrorMessage(
                                context, state.error, state.errorType);
                          }
                          if (state is AddToCartSuccessState) {
                            final items = context.read<CartBloc>().state.items;

                            items.removeWhere(
                                (cartItem) => cartItem.food.id == item.food.id);

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
                      child: CustomIconButton(
                        icon: const Icon(
                            HugeIcons.strokeRoundedShoppingCartRemove02),
                        onPressed: () {
                          context
                              .read<AddRemoveCartBloc>()
                              .add(RemoveFromCartEvent(item.food));
                        },
                      ),
                    );
                  }),
                ),
                BlocProvider(
                  create: (context) => locator<CartQuantityBloc>(),
                  child: CartItemCounter(item: item),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
