import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/features/home/presentation/bloc/restaurants/get_home_restaurants_bloc.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/section_header.dart';
import 'package:your_chef/features/restaurants/domain/entities/restaurant.dart';
import 'package:your_chef/core/widgets/items/restaurant_item.dart';

class RestaurantsSection extends StatelessWidget {
  const RestaurantsSection({
    super.key,
  });

  final double _size = 200;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetHomeRestaurantsBloc, GetHomeRestaurantsState>(
      builder: (context, state) {
        if (state is GetHomeRestaurantsInitialState ||
            (state is GetHomeRestaurantsSuccessState &&
                state.restaurants.isEmpty)) return const SizedBox.shrink();
        if (state is GetHomeRestaurantsErrorState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              SectionHeader(
                title: AppStrings.restaurants,
                onPressed: () {
                  // context.pushNamed(
                  //   AppRoutes.categories,
                  // );
                },
              ),
              CustomErrorWidget(
                error: state.error,
                type: state.errorType,
                onRetry: () => context.read<GetHomeRestaurantsBloc>().add(
                      const GetHomeRestaurantsEventStarted(),
                    ),
              )
            ],
          );
        }
        return SkeletonLoadingWidget(
          loading: state is GetHomeRestaurantsLoadingState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              SectionHeader(
                title: AppStrings.restaurants,
                onPressed: () {},
              ),
              SizedBox(
                height: _size,
                child: _buildRestaurants(
                  restaurants: state is GetHomeRestaurantsLoadingState
                      ? _loadingRestaurants
                      : state is GetHomeRestaurantsSuccessState
                          ? state.restaurants
                          : [],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Restaurant> get _loadingRestaurants => List.generate(
        5,
        (_) => AppDummies.restaurants.first.toEntity(),
      );

  Widget _buildRestaurants({required List<Restaurant> restaurants}) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: restaurants.length,
      separatorBuilder: (_, __) => 10.width,
      itemBuilder: (_, index) => RestaurantItem(
        restaurant: restaurants[index],
        size: _size,
      ),
    );
  }
}
