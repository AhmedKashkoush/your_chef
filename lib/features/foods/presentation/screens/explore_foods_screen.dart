import 'dart:math' hide log;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/fields/search_field.dart';
import 'package:your_chef/core/widgets/items/food_item.dart';
import 'package:your_chef/core/widgets/loading/pizza_loading.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/core/widgets/views/persistent_view.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/foods/presentation/blocs/explore/categories/get_explore_categories_bloc.dart';
import 'package:your_chef/features/foods/presentation/blocs/explore/foods/get_explore_foods_bloc.dart';
import 'package:your_chef/locator.dart';

part '../widgets/explore/categories_tab_bar.dart';
part '../widgets/explore/food_view.dart';

class ExploreFoodsScreen extends StatefulWidget {
  final String selected;
  const ExploreFoodsScreen(
      {super.key, this.selected = AppStrings.popularFoods});

  @override
  State<ExploreFoodsScreen> createState() => _ExploreFoodsScreenState();
}

class _ExploreFoodsScreenState extends State<ExploreFoodsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<GetExploreCategoriesBloc>()
        ..add(const GetExploreCategoriesEventStarted()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            title: Text(AppStrings.exploreFoods.tr()),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight * 2),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0).r,
                    child: SearchField(
                      readOnly: true,
                      hint: AppStrings.searchForFoods.tr(),
                    ),
                  ),
                  4.height,
                  SizedBox(
                    height: 48.h,
                    child: BlocConsumer<GetExploreCategoriesBloc,
                        GetExploreCategoriesState>(
                      listener: (context, state) {
                        if (state is GetExploreCategoriesSuccessState) {
                          _controller = TabController(
                            vsync: this,
                            length: state.categories.length,
                            initialIndex: state.categories.indexOf(
                              state.categories.firstWhere(
                                (element) => element.name == widget.selected,
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return SkeletonLoadingWidget(
                          loading: state is GetExploreCategoriesLoadingState,
                          child: state is GetExploreCategoriesLoadingState
                              ? ListView.separated(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 12)
                                          .r,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  separatorBuilder: (context, index) =>
                                      10.width,
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
                              : state is GetExploreCategoriesSuccessState
                                  ? CategoriesTabBar(
                                      controller: _controller!,
                                      categories: state.categories,
                                    )
                                  : const SizedBox.shrink(),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          backgroundColor: context.theme.colorScheme.surface,
          body:
              BlocBuilder<GetExploreCategoriesBloc, GetExploreCategoriesState>(
            builder: (context, state) {
              if (state is GetExploreCategoriesLoadingState) {
                return const Center(
                  child: PizzaLoading(
                    color: AppColors.primary,
                  ),
                );
              }
              if (state is GetExploreCategoriesErrorState) {
                return CustomErrorWidget(
                  error: state.error,
                  type: state.errorType,
                  onRetry: () => context.read<GetExploreCategoriesBloc>().add(
                        const GetExploreCategoriesEventStarted(),
                      ),
                );
              }
              if (state is GetExploreCategoriesSuccessState) {
                return TabBarView(
                  controller: _controller,
                  children: state.categories
                      .map(
                        (category) => PersistentView(
                          child: BlocProvider(
                            create: (context) => locator<GetExploreFoodsBloc>()
                              ..add(_getExploreFoodsEvent(category)),
                            child: PersistentView(
                              child: FoodView(
                                category: category,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      }),
    );
  }

  GetExploreFoodsEvent _getExploreFoodsEvent(Category category) {
    if (category.name.toLowerCase() == AppStrings.popularFoods.toLowerCase()) {
      return const GetExplorePopularFoodsEvent(
        PaginationOptions(
          limit: 12,
          page: 1,
        ),
      );
    }
    if (category.name.toLowerCase() == AppStrings.onASale.toLowerCase()) {
      return const GetExploreOnASaleFoodsEvent(
        PaginationOptions(
          limit: 12,
          page: 1,
        ),
      );
    }
    return GetExploreFoodsByCategoryEvent(
      PaginationOptions<Category>(
        limit: 12,
        page: 1,
        model: category,
      ),
    );
  }
}
