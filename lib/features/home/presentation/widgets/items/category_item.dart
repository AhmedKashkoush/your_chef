import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/features/home/domain/entities/category.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    required this.size,
  });

  final Category category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Theme.of(context).iconTheme.color?.withOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Image.asset(
              category.image,
              errorBuilder: (_, __, ___) => Container(),
            ),
          ),
          Flexible(child: 5.height),
          Flexible(
            child: Text(
              category.name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
