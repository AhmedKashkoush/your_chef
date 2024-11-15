import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/features/home/domain/entities/category.dart';
import 'package:your_chef/features/home/presentation/widgets/items/category_item.dart';

class CategoriesSection extends StatelessWidget {
  final List<Category> categories;
  const CategoriesSection({
    super.key,
    required this.categories,
  });

  final double _size = 68;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _size.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => 10.width,
        itemBuilder: (_, index) => CategoryItem(
          category: categories[index],
          size: _size,
        ),
      ),
    );
  }
}
