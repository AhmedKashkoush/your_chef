import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
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
        return SkeletonLoadingWidget(
          loading: state is GetHomeOnSaleFoodsLoadingState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              SectionHeader(
                title: AppStrings.onASale,
                onPressed: () {},
              ),
              state is GetHomeOnSaleFoodsErrorState
                  ? CustomErrorWidget(
                      error: state.error,
                      type: state.errorType,
                      onRetry: () => context.read<GetHomeOnSaleFoodsBloc>().add(
                            const GetHomeOnSaleFoodsEventStarted(),
                          ),
                    )
                  : FoodsList(
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
