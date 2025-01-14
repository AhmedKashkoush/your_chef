import 'package:easy_localization/easy_localization.dart';
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
import 'package:your_chef/features/home/presentation/bloc/on_a_sale/get_home_on_sale_foods_bloc.dart';
import 'package:your_chef/features/home/presentation/widgets/foods_list.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/section_header.dart';

class OnSaleFoodsSection extends StatelessWidget {
  const OnSaleFoodsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetHomeOnSaleFoodsBloc, GetHomeOnSaleFoodsState>(
      builder: (context, state) {
        if (state is GetHomeOnSaleFoodsInitialState ||
            (state is GetHomeOnSaleFoodsSuccessState && state.foods.isEmpty)) {
          return const SizedBox.shrink();
        }
        if (state is GetHomeOnSaleFoodsErrorState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              SectionHeader(
                title: AppStrings.onASale.tr(),
              ),
              CustomErrorWidget(
                error: state.error,
                type: state.errorType,
                onRetry: () => context.read<GetHomeOnSaleFoodsBloc>().add(
                      const GetHomeOnSaleFoodsEventStarted(
                        PaginationOptions(limit: 6),
                      ),
                    ),
              )
            ],
          );
        }
        return SkeletonLoadingWidget(
          loading: state is GetHomeOnSaleFoodsLoadingState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              SectionHeader(
                title: AppStrings.onASale.tr(),
                onPressed: () => context.pushNamed(AppRoutes.foods,
                    arguments: AppStrings.onASale),
              ),
              FoodsList(
                loading: state is GetHomeOnSaleFoodsLoadingState,
                foods: state is GetHomeOnSaleFoodsLoadingState
                    ? _loadingOnSaleFoods
                    : state is GetHomeOnSaleFoodsSuccessState
                        ? state.foods
                        : [],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Food> get _loadingOnSaleFoods => List.generate(
        6,
        (_) => AppDummies.foods.first.toEntity(),
      );
}
