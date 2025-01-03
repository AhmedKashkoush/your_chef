import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/items/category_item.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/features/categories/domain/entities/category.dart';
import 'package:your_chef/features/categories/presentation/bloc/get_all_categories_bloc.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllCategoriesBloc, GetAllCategoriesState>(
      builder: (context, state) {
        if (state is GetAllCategoriesInitialState ||
            (state is GetAllCategoriesSuccessState &&
                state.categories.isEmpty)) {
          return const SizedBox.shrink();
        }
        if (state is GetAllCategoriesErrorState) {
          return CustomErrorWidget(
            error: state.error,
            type: state.errorType,
            onRetry: () => context.read<GetAllCategoriesBloc>().add(
                  const GetAllCategoriesEventStarted(),
                ),
          );
        }
        return SkeletonLoadingWidget(
          loading: state is GetAllCategoriesLoadingState,
          child: _buildList(
            loading: state is GetAllCategoriesLoadingState,
            categories: state is GetAllCategoriesLoadingState
                ? _loadingCategories
                : state is GetAllCategoriesSuccessState
                    ? state.categories
                    : [],
          ),
        );
      },
    );
  }

  Widget _buildList(
      {required List<Category> categories, required bool loading}) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: categories.length,
      itemBuilder: (_, index) => CategoryItem(
        category: categories[index],
        size: 68.w,
      ),
    );
  }

  List<Category> get _loadingCategories => List.generate(
        6,
        (_) => AppDummies.categories.first.toEntity(),
      );
}
