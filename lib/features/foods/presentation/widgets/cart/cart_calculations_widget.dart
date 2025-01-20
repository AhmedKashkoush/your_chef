part of '../../screens/cart_screen.dart';

class CartCalculationsWidget extends StatelessWidget {
  final String label;
  final double fontSize;
  final num price;
  const CartCalculationsWidget({
    super.key,
    required this.label,
    required this.fontSize,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: context.theme.iconTheme.color?.withOpacity(0.5),
          ),
        ),
        Text(
          '${price.toStringAsFixed(2)} ${AppStrings.egp.tr()}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
