import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_chef/config/routes/routes.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/home/presentation/bloc/categories/get_home_categories_bloc.dart';
import 'package:your_chef/core/widgets/items/category_item.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/section_header.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
  });

  final double _size = 68;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetHomeCategoriesBloc, GetHomeCategoriesState>(
      builder: (context, state) {
        if (state is GetHomeCategoriesInitialState ||
            (state is GetHomeCategoriesSuccessState &&
                state.categories.isEmpty)) return const SizedBox.shrink();

        if (state is GetHomeCategoriesErrorState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              SectionHeader(
                title: AppStrings.availableCategories,
                onPressed: () {
                  context.pushNamed(
                    AppRoutes.categories,
                  );
                },
              ),
              10.height,
              CustomErrorWidget(
                error: state.error,
                type: state.errorType,
                onRetry: () => context.read<GetHomeCategoriesBloc>().add(
                      const GetHomeCategoriesEventStarted(
                        GetCategoriesOptions(),
                      ),
                    ),
              )
            ],
          );
        }
        return SkeletonLoadingWidget(
          loading: state is GetHomeCategoriesLoadingState,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Divider(),
            SectionHeader(
              title: AppStrings.availableCategories,
              onPressed: () {
                context.pushNamed(
                  AppRoutes.categories,
                );
              },
            ),
            10.height,
            SizedBox(
              height: _size,
              child: _buildList(
                  categories: state is GetHomeCategoriesLoadingState
                      ? _loadingList
                      : state is GetHomeCategoriesSuccessState
                          ? state.categories
                          : []),
            ),
          ]),
        );
      },
    );
  }

  ListView _buildList({required List<Category> categories}) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      separatorBuilder: (_, __) => 10.width,
      itemBuilder: (_, index) => CategoryItem(
        category: categories[index],
        size: _size,
      ),
    );
  }

  List<Category> get _loadingList => List.generate(
        5,
        (_) => AppDummies.categories.first.toEntity(),
      );
}
