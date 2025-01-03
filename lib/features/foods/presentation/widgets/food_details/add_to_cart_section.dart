import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/core/widgets/buttons/secondary_button.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';

class AddToCartSection extends StatefulWidget {
  const AddToCartSection({
    super.key,
    required this.inCart,
    this.count = 0,
    required this.food,
  });

  final int count;
  final bool inCart;
  final Food food;

  @override
  State<AddToCartSection> createState() => _AddToCartSectionState();
}

class _AddToCartSectionState extends State<AddToCartSection> {
  // late final int _count = widget.count;

  // List<Widget> get _buildCounter {
  //   return [
  //     IconButton.filledTonal(
  //       onPressed: _remove,
  //       icon: const Icon(
  //         HugeIcons.strokeRoundedMinusSign,
  //       ),
  //     ),
  //     10.width,
  //     Text('$_count'),
  //     10.width,
  //     IconButton.filledTonal(
  //       onPressed: _add,
  //       icon: const Icon(
  //         HugeIcons.strokeRoundedPlusSign,
  //       ),
  //     ),
  //   ];
  // }

  // void _add() {
  //   if (_count == 100) return;
  //   setState(() {
  //     _count += 1;
  //   });
  // }

  // void _remove() {
  //   if (_count == 0) return;
  //   setState(() {
  //     _count -= 1;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.inCart
          ? Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: AppStrings.removeFromCart,
                    icon: HugeIcons.strokeRoundedShoppingCartRemove01,
                    onPressed: () {},
                  ),
                ),
                10.width,
                Expanded(
                  child: PrimaryButton(
                    text: AppStrings.viewInCart,
                    icon: HugeIcons.strokeRoundedShoppingCart01,
                    backgroundColor: Colors.green,
                    count: widget.count,
                    onPressed: () {},
                  ),
                ),
                // 10.width,
                // ..._buildCounter,
              ],
            )
          : PrimaryButton(
              text: AppStrings.addToCart,
              icon: HugeIcons.strokeRoundedShoppingCartAdd01,
              onPressed: () {},
            ),
    );
  }
}
