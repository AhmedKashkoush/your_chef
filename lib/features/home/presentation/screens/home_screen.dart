import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/dummy/dummy_data.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/utils/user_helper.dart';
import 'package:your_chef/core/widgets/app_bars/custom_app_bar.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/features/home/presentation/bloc/home_bloc.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/categories_section.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/foods_section.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/offers_section.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/restaurants_section.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _load(BuildContext context) async {
    context.read<HomeBloc>().add(const GetHomeDataEvent());
  }

  final String _tag = 'home-user-image';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (context.isLandscape)
          Container(
            width: 36.w,
            color: context.theme.colorScheme.surface,
          ),
        Expanded(
          child: Scaffold(
            backgroundColor: context.theme.colorScheme.surface,
            appBar: CustomAppBar(
              profileTag: _tag,
            ),
            body: BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
              if (state.errorType == ErrorType.network) {
                AppMessages.showErrorMessage(
                    context, state.error, state.errorType);
              }
            }, builder: (context, state) {
              if (state.status == RequestStatus.failure) {
                return CustomErrorWidget(
                  onRetry: () => _load(context),
                  error: state.error,
                  type: state.errorType,
                );
              }
              return SkeletonLoadingWidget(
                loading: state.status == RequestStatus.loading,
                child: RefreshIndicator.adaptive(
                  color: AppColors.primary,
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    if (!context.mounted) return;
                    _load(context);
                  },
                  child: ListView(
                    primary: false,
                    cacheExtent: 3000,
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 88.0,
                    ).r,
                    children: [
                      Text(
                        '${AppStrings.welcomeUser} ${UserHelper.user?.name.split(' ').first}! 👋',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text.rich(
                        const TextSpan(
                          text: "${AppStrings.homeDisclaimer} ",
                          children: [
                            TextSpan(
                              text: 'Palestine 🇵🇸',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              context.theme.iconTheme.color?.withOpacity(0.3),
                        ),
                      ),
                      30.height,
                      if (state.offers.isNotEmpty ||
                          state.status == RequestStatus.loading) ...[
                        const SectionHeader(
                          title: AppStrings.todaysOffers,
                          // onPressed: () {},
                        ),
                        10.height,
                        OffersSection(
                          loading: state.status == RequestStatus.loading,
                          offers: state.status == RequestStatus.loading
                              ? [AppDummies.offers.first.toEntity()]
                              : state.offers,
                        ),
                      ],
                      //?Categories
                      if (state.categories.isNotEmpty ||
                          state.status == RequestStatus.loading) ...[
                        const Divider(),
                        SectionHeader(
                          title: AppStrings.availableCategories,
                          onPressed: () {},
                        ),
                        10.height,
                        CategoriesSection(
                          categories: state.status == RequestStatus.loading
                              ? List.generate(
                                  5,
                                  (_) => AppDummies.categories.first.toEntity(),
                                )
                              : state.categories,
                        ),
                      ],
                      //?Restaurants
                      if (state.restaurants.isNotEmpty ||
                          state.status == RequestStatus.loading) ...[
                        const Divider(),
                        SectionHeader(
                          title: AppStrings.restaurants,
                          onPressed: () {},
                        ),
                        RestaurantsSection(
                          restaurants: state.status == RequestStatus.loading
                              ? List.generate(
                                  5,
                                  (_) =>
                                      AppDummies.restaurants.first.toEntity(),
                                )
                              : state.restaurants,
                        ),
                      ],
                      //?Popular Foods
                      if (state.popularProducts.isNotEmpty ||
                          state.status == RequestStatus.loading) ...[
                        const Divider(),
                        SectionHeader(
                          title: AppStrings.popularFoods,
                          onPressed: () {},
                        ),
                        FoodsSection(
                          foods: state.status == RequestStatus.loading
                              ? List.generate(
                                  5,
                                  (_) => AppDummies.foods.first.toEntity(),
                                )
                              : state.popularProducts,
                        ),
                      ],
                      //?On A Sale Foods
                      if (state.onSaleProducts.isNotEmpty ||
                          state.status == RequestStatus.loading) ...[
                        const Divider(),
                        SectionHeader(
                          title: AppStrings.onASale,
                          onPressed: () {},
                        ),
                        FoodsSection(
                          foods: state.status == RequestStatus.loading
                              ? List.generate(
                                  5, (_) => AppDummies.foods.first.toEntity())
                              : state.onSaleProducts,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
