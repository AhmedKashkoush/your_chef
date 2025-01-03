import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/features/categories/presentation/bloc/get_all_categories_bloc.dart';
import 'package:your_chef/features/categories/presentation/widgets/categories_list.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/section_header.dart';
import 'package:your_chef/locator.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: AppStrings.exploreByCategories),
              40.height,
              Expanded(
                child: BlocProvider(
                  create: (context) => locator<GetAllCategoriesBloc>()
                    ..add(const GetAllCategoriesEventStarted()),
                  child: const CategoriesList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
