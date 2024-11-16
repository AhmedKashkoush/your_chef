import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/home/presentation/widgets/items/product_item.dart';

class FoodsSection extends StatelessWidget {
  final List<Product> foods;
  const FoodsSection({
    super.key,
    required this.foods,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.isPortrait ? 2 : 3,
          crossAxisSpacing: 6.w,
          mainAxisSpacing: 6.h,
        ),
        shrinkWrap: true,
        primary: false,
        itemCount: foods.length,
        itemBuilder: (_, index) => ProductItem(
          food: foods[index],
        ),
      ),
    );
  }
}
