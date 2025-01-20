part of '../../screens/cart_screen.dart';

class CartCounter extends StatelessWidget {
  final int count;
  const CartCounter({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(8.0).r,
      padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(const Radius.circular(25).r),
        color: AppColors.primary,
      ),
      child: Text(
        count > 99 ? "+99" : count.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
