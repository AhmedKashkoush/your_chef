part of '../../screens/cart_screen.dart';

class OrderOverviewWidget extends StatelessWidget {
  const OrderOverviewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state.items.isEmpty && state.status != RequestStatus.loading) {
        return const SizedBox.shrink();
      }
      return AnimatedSlide(
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 300),
        offset: Offset(0, state.status == RequestStatus.loading ? 1 : 0),
        child: Container(
          color: context.theme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0).r,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CartCalculationsWidget(
                    label: AppStrings.subtotal.tr(),
                    fontSize: 16.sp,
                    price: state.total,
                  ),
                  10.height,
                  CartCalculationsWidget(
                    label: AppStrings.fees.tr(),
                    fontSize: 16.sp,
                    price: state.fees,
                  ),
                  10.height,
                  CartCalculationsWidget(
                    label: AppStrings.total.tr(),
                    fontSize: 20.sp,
                    price: state.total + state.fees,
                    priceColor: AppColors.primary,
                    labelColor: context.theme.iconTheme.color,
                  ),
                  16.height,
                  PrimaryButton(
                    text:
                        '${AppStrings.checkout.tr()} ${(state.total + state.fees).asThousands} ${AppStrings.egp.tr()}',
                    onPressed: () {},
                    fontSize: 18.sp,
                    padding: const EdgeInsets.symmetric(vertical: 8).r,
                  ),
                ]),
          ),
        ),
      );
    });
  }
}
