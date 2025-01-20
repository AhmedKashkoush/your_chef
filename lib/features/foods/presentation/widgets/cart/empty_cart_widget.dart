part of '../../screens/cart_screen.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0).r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              HugeIcons.strokeRoundedShoppingCart02,
              size: 100.r,
              color: context.theme.iconTheme.color?.withOpacity(0.3),
            ),
            Text(
              AppStrings.yourCartIsEmpty.tr(),
              textAlign: TextAlign.center,
              style: context.theme.textTheme.titleLarge?.copyWith(
                color: context.theme.iconTheme.color?.withOpacity(0.3),
              ),
            ),
            30.height,
            PrimaryButton(
              text: AppStrings.exploreFoods.tr(),
              icon: Icons.explore_outlined,
              onPressed: () {
                context.pushNamed(AppRoutes.foods);
              },
            ),
          ],
        ),
      ),
    );
  }
}
