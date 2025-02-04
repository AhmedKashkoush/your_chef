import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/buttons/custom_icon_button.dart';
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
        leading: context.canPop()
            ? Padding(
                padding: const EdgeInsets.all(8.0).r,
                child: CustomIconButton(
                  icon: const BackButtonIcon(),
                  onPressed: () => context.pop(),
                ),
              )
            : null,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: AppStrings.exploreByCategories.tr()),
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
