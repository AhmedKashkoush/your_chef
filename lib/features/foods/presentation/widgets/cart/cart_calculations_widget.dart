part of '../../screens/cart_screen.dart';

class CartCalculationsWidget extends StatelessWidget {
  final String label;
  final double fontSize;
  final num price;
  final Color? labelColor, priceColor;
  const CartCalculationsWidget({
    super.key,
    required this.label,
    required this.fontSize,
    required this.price,
    this.labelColor,
    this.priceColor,
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
            color:
                labelColor ?? context.theme.iconTheme.color?.withOpacity(0.5),
          ),
        ),
        Text(
          '${price.toStringAsFixed(2)} ${AppStrings.egp.tr()}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color:
                priceColor ?? context.theme.iconTheme.color?.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
