import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/widgets/app_bars/custom_app_bar.dart';
import 'package:your_chef/features/home/presentation/bloc/categories/get_home_categories_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/offers/get_home_offers_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/on_a_sale/get_home_on_sale_foods_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/popular_foods/get_home_popular_foods_bloc.dart';
import 'package:your_chef/features/home/presentation/bloc/restaurants/get_home_restaurants_bloc.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/categories_section.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/offers_section.dart';
import 'package:your_chef/common/blocs/user/user_bloc.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/on_sale_foods_section.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/popular_foods_section.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/restaurants_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _loadOffers(BuildContext context) async {
    context.read<GetHomeOffersBloc>().add(
          const GetHomeOffersEventStarted(),
        );
  }

  Future<void> _loadCategories(BuildContext context) async {
    context.read<GetHomeCategoriesBloc>().add(
          const GetHomeCategoriesEventStarted(
            GetCategoriesOptions(),
          ),
        );
  }

  Future<void> _loadRestaurants(BuildContext context) async {
    context.read<GetHomeRestaurantsBloc>().add(
          const GetHomeRestaurantsEventStarted(
            PaginationOptions(limit: 5),
          ),
        );
  }

  Future<void> _loadPopularFoods(BuildContext context) async {
    context.read<GetHomePopularFoodsBloc>().add(
          const GetHomePopularFoodsEventStarted(
            PaginationOptions(limit: 6),
          ),
        );
  }

  Future<void> _loadOnSaleFoods(BuildContext context) async {
    context.read<GetHomeOnSaleFoodsBloc>().add(
          const GetHomeOnSaleFoodsEventStarted(
            PaginationOptions(limit: 6),
          ),
        );
  }

  String get _tag => 'home-user-image';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: CustomAppBar(
        profileTag: _tag,
        isLogoHero: true,
      ),
      body: SafeArea(
        bottom: false,
        top: false,
        child: RefreshIndicator.adaptive(
          color: AppColors.primary,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            if (!context.mounted) return;
            _loadCategories(context);
            _loadOffers(context);
            _loadRestaurants(context);
            _loadPopularFoods(context);
            _loadOnSaleFoods(context);
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
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return Text(
                    '${AppStrings.welcomeUser} ${state.user?.name.split(' ').first}! 👋',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
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
                  color: context.theme.iconTheme.color?.withOpacity(0.3),
                ),
              ),
              30.height,
              //?Offers
              const OffersSection(),
              //?Categories
              const CategoriesSection(),
              //?Restaurants
              const RestaurantsSection(),
              //?Popular Foods
              const PopularFoodsSection(),
              //?On A Sale Foods
              const OnSaleFoodsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
