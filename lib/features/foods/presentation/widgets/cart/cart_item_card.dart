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
                      '${item.food.price} ${AppStrings.egp.tr()}',
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
                CustomIconButton(
                  icon: const Icon(HugeIcons.strokeRoundedShoppingCartRemove02),
                  onPressed: () {
                    context
                        .read<CartBloc>()
                        .add(RemoveFoodFromCartEvent(item.food));
                  },
                ),
                CartItemCounter(item: item),
              ],
            )
          ],
        ),
      ),
    );
  }
}

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
      context.read<CartBloc>().add(
            IncrementCartItemEvent(
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
      context.read<CartBloc>().add(
            IncrementCartItemEvent(
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
      children: [
        CustomIconButton(
          onPressed: () => _decrement(context),
          icon: const Icon(Icons.remove),
          backgroundColor: context.theme.iconTheme.color?.withOpacity(0.2),
        ),
        10.width,
        BlocConsumer<CartBloc, CartState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == RequestStatus.failure) {
              AppMessages.showErrorMessage(
                  context, state.error, state.errorType);
              _counter = widget.item.quantity;
            }
            if (state.status == RequestStatus.success &&
                state.message.isNotEmpty) {
              AppMessages.showSuccessMessage(
                context,
                state.message,
              );
            }
          },
          builder: (context, state) {
            return Text(_counter.toString());
          },
        ),
        10.width,
        CustomIconButton(
          onPressed: () => _increment(context),
          icon: const Icon(Icons.add),
          backgroundColor: context.theme.iconTheme.color?.withOpacity(0.2),
        ),
      ],
    );
  }
}
