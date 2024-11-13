import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';

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
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      shrinkWrap: true,
      primary: false,
      itemCount: foods.length,
      itemBuilder: (_, index) => Container(
        width: 180.w,
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
    );
  }
}
