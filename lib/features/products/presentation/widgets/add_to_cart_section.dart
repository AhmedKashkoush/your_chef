import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/buttons/primary_button.dart';
import 'package:your_chef/core/widgets/buttons/secondary_button.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';

class AddToCartSection extends StatefulWidget {
  final bool inCart;
  final int count;
  final Product product;
  const AddToCartSection({
    super.key,
    required this.inCart,
    this.count = 0,
    required this.product,
  });

  @override
  State<AddToCartSection> createState() => _AddToCartSectionState();
}

class _AddToCartSectionState extends State<AddToCartSection> {
  late int _count = widget.count;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.inCart
          ? Row(
              children: [
                Expanded(
                  // flex: 3,
                  child: SecondaryButton(
                    text: context.isLandscape ? 'Remove' : '',
                    icon: HugeIcons.strokeRoundedShoppingCartRemove01,
                    onPressed: () {},
                  ),
                ),
                10.width,
                Expanded(
                  // flex: 3,
                  child: PrimaryButton(
                    text: context.isLandscape ? 'Add' : '',
                    icon: HugeIcons.strokeRoundedShoppingCartAdd01,
                    onPressed:
                        _count > 0 && _count != widget.count ? () {} : null,
                  ),
                ),
                10.width,
                // const Spacer(),
                IconButton.filledTonal(
                  onPressed: _remove,

                  // color: AppColors.primary.withOpacity(0.5),
                  icon: const Icon(
                    HugeIcons.strokeRoundedMinusSign,
                  ),
                ),
                10.width,
                Text('$_count'),
                10.width,
                IconButton.filledTonal(
                  onPressed: _add,
                  // color: AppColors.primary.withOpacity(0.5),
                  icon: const Icon(
                    HugeIcons.strokeRoundedPlusSign,
                  ),
                ),
              ],
            )
          : PrimaryButton(
              text: 'Add to Cart',
              icon: HugeIcons.strokeRoundedShoppingCart01,
              onPressed: () {},
            ),
    );
  }

  void _add() {
    if (_count == 100) return;
    setState(() {
      _count += 1;
    });
  }

  void _remove() {
    if (_count == 0) return;
    setState(() {
      _count -= 1;
    });
  }
}
