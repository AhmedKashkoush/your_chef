import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';

class ExploreFoodsScreen extends StatefulWidget {
  final String selected;
  const ExploreFoodsScreen(
      {super.key, this.selected = AppStrings.popularFoods});

  @override
  State<ExploreFoodsScreen> createState() => _ExploreFoodsScreenState();
}

class _ExploreFoodsScreenState extends State<ExploreFoodsScreen> {
  List<String> get _categories => [
        AppStrings.popularFoods,
        AppStrings.onASale,
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(AppStrings.exploreFoods),
        //TODO: Add search bar in the bottom property
      ),
      body: Column(
        children: [
          //TODO: add blocs
          SizedBox(
            height: 64.h,
            child: SkeletonLoadingWidget(
              loading: false,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16).r,
                scrollDirection: Axis.horizontal,
                itemCount: [..._categories, ...AppDummies.categories].length,
                separatorBuilder: (context, index) => 10.width,
                itemBuilder: (context, index) => ChoiceChip(
                  label: Text([
                    ..._categories,
                    ...AppDummies.categories.map((e) => e.name)
                  ][index]),
                  selectedColor: AppColors.primary,
                  showCheckmark: false,
                  selected: [
                    ..._categories,
                    ...AppDummies.categories.map((e) => e.name)
                  ][index]
                      .toLowerCase()
                      .contains(widget.selected.toLowerCase()),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ),
          //TODO: add food list
          const Spacer(),
        ],
      ),
    );
  }
}
