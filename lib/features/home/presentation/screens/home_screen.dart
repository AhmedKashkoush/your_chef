import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/config/routes/routes.dart';

import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/utils/user_helper.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/fields/search_field.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/features/home/domain/entities/category.dart';
import 'package:your_chef/features/home/domain/entities/offer.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/home/domain/entities/restaurant.dart';
import 'package:your_chef/features/home/presentation/bloc/home_bloc.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/categories_section.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/foods_section.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/offers_section.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/restaurants_section.dart';
import 'package:your_chef/features/home/presentation/widgets/sections/section_header.dart';

import '../../../../core/widgets/avatars/user_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _load(BuildContext context) async {
    context.read<HomeBloc>().add(const GetHomeDataEvent());
  }

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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              titleSpacing: 8.w,
              title: Row(
                children: [
                  Hero(
                    tag: 'user-image',
                    child: UserAvatar(
                      radius: 20,
                      url: UserHelper.user?.image ?? '',
                      onTap: () => _goToProfile(context),
                    ),
                  ),
                  10.width,
                  const Expanded(
                    child: SearchField(
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Badge.count(
                    count: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    child: const Icon(HugeIcons.strokeRoundedNotification03),
                  ),
                ),
              ],
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
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 88.0,
                    ).r,
                    children: [
                      Text(
                        'Welcome ${UserHelper.user?.name.split(' ').first}! 👋',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text.rich(
                        const TextSpan(
                          text: "Don't forget to pray for ",
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
                          title: "Today's Offers",
                          // onPressed: () {},
                        ),
                        10.height,
                        OffersSection(
                          loading: state.status == RequestStatus.loading,
                          offers: state.status == RequestStatus.loading
                              ? [
                                  const Offer(
                                    id: 0,
                                    restaurantId: 0,
                                    image: '',
                                  ),
                                ]
                              : state.offers,
                        ),
                      ],
                      //?Categories
                      if (state.categories.isNotEmpty ||
                          state.status == RequestStatus.loading) ...[
                        const Divider(),
                        SectionHeader(
                          title: "Available Categories",
                          onPressed: () {},
                        ),
                        10.height,
                        CategoriesSection(
                          categories: state.status == RequestStatus.loading
                              ? List.generate(
                                  5,
                                  (_) => const Category(
                                      id: 0, name: '', image: ''),
                                )
                              : state.categories,
                        ),
                      ],
                      //?Restaurants
                      if (state.restaurants.isNotEmpty ||
                          state.status == RequestStatus.loading) ...[
                        const Divider(),
                        SectionHeader(
                          title: "Restaurants",
                          onPressed: () {},
                        ),
                        RestaurantsSection(
                          restaurants: state.status == RequestStatus.loading
                              ? List.generate(
                                  5,
                                  (_) => const Restaurant(
                                    id: 0,
                                    name: '',
                                    address: '',
                                    description: '',
                                    images: [],
                                    phone: '',
                                    profileImage: '',
                                    rate: 0,
                                  ),
                                )
                              : state.restaurants,
                        ),
                      ],
                      //?Popular Foods
                      if (state.popularProducts.isNotEmpty ||
                          state.status == RequestStatus.loading) ...[
                        const Divider(),
                        SectionHeader(
                          title: "Popular Foods",
                          onPressed: () {},
                        ),
                        FoodsSection(
                          foods: state.status == RequestStatus.loading
                              ? List.generate(
                                  5,
                                  (_) => const Product(
                                    id: 0,
                                    categoryId: 0,
                                    restaurantId: 0,
                                    name: '',
                                    description: '',
                                    price: 0,
                                    rate: 0,
                                    sale: 0,
                                    trending: false,
                                    images: [],
                                  ),
                                )
                              : state.popularProducts,
                        ),
                      ],
                      //?On A Sale Foods
                      if (state.onSaleProducts.isNotEmpty ||
                          state.status == RequestStatus.loading) ...[
                        const Divider(),
                        SectionHeader(
                          title: "On A Sale",
                          onPressed: () {},
                        ),
                        FoodsSection(
                          foods: state.status == RequestStatus.loading
                              ? List.generate(
                                  5,
                                  (_) => const Product(
                                    id: 0,
                                    categoryId: 0,
                                    restaurantId: 0,
                                    name: '',
                                    description: '',
                                    price: 0,
                                    rate: 0,
                                    sale: 0,
                                    trending: false,
                                    images: [],
                                  ),
                                )
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

  void _goToProfile(BuildContext context) => context.pushNamed(
        AppRoutes.profile,
        arguments: 'user-image',
      );
}
