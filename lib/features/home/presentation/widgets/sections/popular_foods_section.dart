import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/features/foods/domain/entities/food.dart';
import 'package:your_chef/features/home/presentation/bloc/popular_foods/get_home_popular_foods_bloc.dart';
import 'package:your_chef/features/home/presentation/widgets/foods_list.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/section_header.dart';

class PopularFoodsSection extends StatelessWidget {
  const PopularFoodsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetHomePopularFoodsBloc, GetHomePopularFoodsState>(
      builder: (context, state) {
        if (state is GetHomePopularFoodsInitialState ||
            (state is GetHomePopularFoodsSuccessState && state.foods.isEmpty)) {
          return const SizedBox.shrink();
        }
        if (state is GetHomePopularFoodsErrorState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              const SectionHeader(
                title: AppStrings.popularFoods,
              ),
              CustomErrorWidget(
                error: state.error,
                type: state.errorType,
                onRetry: () => context.read<GetHomePopularFoodsBloc>().add(
                      const GetHomePopularFoodsEventStarted(
                        PaginationOptions(limit: 6),
                      ),
                    ),
              )
            ],
          );
        }
        return SkeletonLoadingWidget(
          loading: state is GetHomePopularFoodsLoadingState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              SectionHeader(
                title: AppStrings.popularFoods,
                onPressed: () => context.pushNamed(
                  AppRoutes.foods,
                  arguments: AppStrings.popularFoods,
                ),
              ),
              FoodsList(
                loading: state is GetHomePopularFoodsLoadingState,
                foods: state is GetHomePopularFoodsLoadingState
                    ? _loadingPopularFoods
                    : state is GetHomePopularFoodsSuccessState
                        ? state.foods
                        : [],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Food> get _loadingPopularFoods => List.generate(
        6,
        (_) => AppDummies.foods.first.toEntity(),
      );
}
