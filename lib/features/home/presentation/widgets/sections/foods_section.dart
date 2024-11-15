import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.h,
      ),
      shrinkWrap: true,
      primary: false,
      itemCount: foods.length,
      itemBuilder: (_, index) => ProductItem(
        food: foods[index],
      ),
    );
  }
}
