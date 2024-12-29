import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/core/widgets/separators/card_divider_widget.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/core/widgets/items/restaurant_menu_item.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/features/restaurants/presentation/bloc/menu/get_restaurant_menu_bloc.dart';
import 'package:your_chef/features/restaurants/presentation/widgets/tiles/restaurant_menu_tile.dart';

class RestaurantMenuListSection extends StatelessWidget {
  const RestaurantMenuListSection({
    super.key,
    required this.tag,
    required this.restaurant,
  });

  final Restaurant restaurant;
  final String tag;

  Widget _buildEmptyMenu(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            HugeIcons.strokeRoundedMenuRestaurant,
            size: 120.sp,
            color: AppColors.primary,
          ),
          10.height,
          Text(
            'We will add menu soon',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: context.theme.iconTheme.color?.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        16.height,
        const CardDividerWidget(),
        8.height,
        const RestaurantMenuTile(),
        8.height,
        BlocBuilder<GetRestaurantMenuBloc, GetRestaurantMenuState>(
          builder: (_, state) {
            if (state is GetRestaurantMenuLoadingState) {
              return SkeletonLoadingWidget(
                loading: true,
                child: _buildList(foods: _loadingList, loading: true),
              );
            }

            if (state is GetRestaurantMenuErrorState) {
              return CustomErrorWidget(
                error: state.error,
                onRetry: () => context.read<GetRestaurantMenuBloc>().add(
                      GetRestaurantMenuEventStarted(
                        RestaurantOptions(
                          restaurant: restaurant,
                        ),
                      ),
                    ),
              );
            }
            if (state is GetRestaurantMenuSuccessState) {
              if (state.foods.isEmpty) {
                return _buildEmptyMenu(context);
              }

              final List<Food> normalFoods =
                  state.foods.where((food) => food.sale == 0).toList();
              final List<Food> saleFoods =
                  state.foods.where((food) => food.sale > 0).toList();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (saleFoods.isNotEmpty) ...[
                    if (saleFoods.isNotEmpty && normalFoods.isNotEmpty)
                      _buildTitleTile(context, title: AppStrings.onASale),
                    _buildList(foods: saleFoods, loading: false),
                  ],
                  if (normalFoods.isNotEmpty) ...[
                    if (saleFoods.isNotEmpty && normalFoods.isNotEmpty)
                      _buildTitleTile(
                        context,
                        title: AppStrings.other,
                      ),
                    _buildList(foods: normalFoods, loading: false),
                  ]
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  List<Food> get _loadingList =>
      List.generate(10, (index) => AppDummies.foods.first.toEntity());

  Widget _buildTitleTile(BuildContext context, {required String title}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: context.theme.iconTheme.color?.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildList({required List<Food> foods, required bool loading}) {
    return ListView.separated(
      itemBuilder: (_, index) => RestaurantMenuItem(
        food: foods[index],
        tag: loading ? tag + index.toString() : tag,
      ),
      separatorBuilder: (_, index) => 8.height,
      itemCount: foods.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
