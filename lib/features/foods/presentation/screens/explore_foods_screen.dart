import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/fields/search_field.dart';
import 'package:your_chef/core/widgets/items/food_item.dart';
import 'package:your_chef/core/widgets/loading/pizza_loading.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';

class ExploreFoodsScreen extends StatefulWidget {
  final String selected;
  const ExploreFoodsScreen(
      {super.key, this.selected = AppStrings.popularFoods});

  @override
  State<ExploreFoodsScreen> createState() => _ExploreFoodsScreenState();
}

class _ExploreFoodsScreenState extends State<ExploreFoodsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  List<Category> get _categories => [
        const Category(id: 0, name: AppStrings.popularFoods, image: ''),
        const Category(id: 0, name: AppStrings.onASale, image: ''),
        ...AppDummies.categories.map((e) => e.toEntity())
      ];
  bool loading = true;
  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 2),
        () => setState(() {
              loading = false;
              _controller = TabController(
                  vsync: this,
                  length: _categories.length,
                  initialIndex: _categories.indexOf(_categories.firstWhere(
                      (element) => element.name == widget.selected)));
            }));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: const Text(AppStrings.exploreFoods),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight * 2),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0).r,
                child: const SearchField(
                  readOnly: true,
                  hint: AppStrings.searchForFoods,
                ),
              ),
              4.height,
              SizedBox(
                height: 48.h,
                child: SkeletonLoadingWidget(
                  loading: loading,
                  child: loading
                      ? ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 12).r,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          separatorBuilder: (context, index) => 10.width,
                          itemBuilder: (context, index) => ChoiceChip(
                            label: Text(
                              'cat' * max(1, Random().nextInt(4)),
                            ),
                            selectedColor: AppColors.primary,
                            showCheckmark: false,
                            selected: false,
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                        )
                      : TabBar(
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicator: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor:
                              context.theme.iconTheme.color?.withOpacity(0.5),
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          controller: _controller,
                          tabs: _categories
                              .map((category) => Tab(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0)
                                          .r,
                                      child: Row(
                                        children: [
                                          if (category.image.isNotEmpty) ...[
                                            Image.asset(
                                              category.image,
                                              width: 20.w,
                                            ),
                                            10.width,
                                          ],
                                          Text(category.name),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList()),
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: context.theme.colorScheme.surface,
      body: loading
          ? const Center(
              child: PizzaLoading(
                color: AppColors.primary,
              ),
            )
          : TabBarView(
              controller: _controller,
              children: _categories
                  .map(
                    (e) => SkeletonLoadingWidget(
                      loading: true,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10.0).r,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 10.w,
                        ),
                        itemCount: Random().nextInt(10),
                        itemBuilder: (_, index) => FoodItem(
                          food: AppDummies.foods.first.toEntity(),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
