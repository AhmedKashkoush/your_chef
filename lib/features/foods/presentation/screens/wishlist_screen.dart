import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/constants/strings.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/messages.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/widgets/app_bars/custom_app_bar.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/common/blocs/wishlist/wishlist_bloc.dart';
import 'package:your_chef/features/foods/presentation/widgets/wishlist/empty_wishlist_widget.dart';
import 'package:your_chef/features/foods/presentation/widgets/wishlist/wishlist_view_widget.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  int _page = 1;
  final String _tag = 'wishlist-user-image';
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    // _load();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  void _load() {
    context.read<WishlistBloc>().add(
          GetFoodsWishlistEvent(
            PaginationOptions(
              page: _page,
            ),
          ),
        );
  }

  void _scrollListener() {
    if (!_controller.hasClients) return;
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      if (!context.read<WishlistBloc>().state.foodsHasNext) return;
      if (context.read<WishlistBloc>().state.error.isNotEmpty) return;
      context.read<WishlistBloc>().add(
            GetFoodsWishlistEvent(
              PaginationOptions(
                page: _page,
              ),
            ),
          );
    }
  }

  Future<void> _refresh(BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    if (!context.mounted) return;
    _page = 1;
    context.read<WishlistBloc>().add(
          const RefreshFoodsWishlistEvent(
            PaginationOptions(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: CustomAppBar(
        profileTag: _tag,
      ),
      body: BlocProvider.value(
        value: context.read<WishlistBloc>()
          ..add(
            GetFoodsWishlistEvent(
              PaginationOptions(
                page: _page,
              ),
            ),
          ),
        child: Builder(builder: (context) {
          return BlocConsumer<WishlistBloc, WishlistState>(
            listener: (context, state) {
              if (!state.addOrRemove) {
                if (state.status == RequestStatus.success) {
                  _page++;
                }
                return;
              }
              if (state.status == RequestStatus.loading) {
                AppMessages.showLoadingDialog(
                  context,
                  message: AppStrings.justAMoment.tr(),
                );
              } else {
                Navigator.pop(context);
                if (state.status == RequestStatus.success) {
                  AppMessages.showSuccessMessage(
                    context,
                    AppStrings.itemRemoved.tr(),
                  );
                } else {
                  AppMessages.showErrorMessage(context, state.error);
                }
              }
            },
            builder: (context, state) {
              if (state.status == RequestStatus.initial) {
                return const SizedBox.shrink();
              }
              if (state.foods.isEmpty) {
                if (state.status == RequestStatus.loading &&
                    !state.addOrRemove) {
                  return SkeletonLoadingWidget(
                    loading: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          child: Text(
                            '${state.foods.length} ${state.foods.length == 1 ? AppStrings.item.tr() : AppStrings.items.tr()}',
                            style: context.theme.textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: WishlistViewWidget(
                            foods: [],
                            loading: true,
                            // error: state.status != RequestStatus.failure
                            //     ? ''
                            //     : state.error,
                            // errorType: state.errorType,
                            // loading: state.status == RequestStatus.loading,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.status == RequestStatus.failure &&
                    !state.addOrRemove) {
                  return CustomErrorWidget(
                    error: state.error,
                    type: state.errorType,
                    onRetry: () => _load(),
                  );
                }
                return const EmptyWishlistWidget();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    child: Text(
                      '${state.foods.length} ${state.foods.length == 1 ? AppStrings.item.tr() : AppStrings.items.tr()}',
                      style: context.theme.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: WishlistViewWidget(
                      onRefresh: () => _refresh(context),
                      onRetry: () => _load(),
                      controller: _controller,
                      foods: state.foods,
                      error: state.status != RequestStatus.failure &&
                              !state.addOrRemove
                          ? ''
                          : state.error,
                      errorType: state.errorType,
                      loading: state.status == RequestStatus.loading &&
                          !state.addOrRemove,
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  // Widget _buildView({
  //   required List<Product> foods,
  //   bool loading = false,
  //   String error = '',
  //   ErrorType errorType = ErrorType.normal,
  // }) {
  //   return ListView.separated(
  //     controller: _controller,
  //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
  //     itemBuilder: (_, index) {
  //       if (index == foods.length) {
  //         if (loading) {
  //           return SkeletonLoadingWidget(
  //             loading: loading,
  //             child: const WishlistItem(
  //               food: Product(
  //                 id: 0,
  //                 categoryId: 0,
  //                 restaurantId: 0,
  //                 name: '',
  //                 description: '',
  //                 images: [],
  //                 price: 0,
  //                 rate: 0,
  //                 sale: 0,
  //                 trending: false,
  //               ),
  //             ),
  //           );
  //         }

  //         if (error.isNotEmpty) {
  //           return CustomErrorWidget(
  //             error: error,
  //             type: errorType,
  //             onRetry: () => _load(),
  //           );
  //         }

  //         return const SizedBox.shrink();
  //       }
  //       return WishlistItem(
  //         food: foods[index],
  //       );
  //     },
  //     separatorBuilder: (_, __) => 10.height,
  //     itemCount: foods.length + 1,
  //   );
  //   // final bool isPortrait =
  //   //     MediaQuery.of(context).orientation == Orientation.portrait;
  //   // return GridView.builder(
  //   //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
  //   //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //   //     crossAxisCount: isPortrait ? 2 : 3,
  //   //     crossAxisSpacing: 10.w,
  //   //     mainAxisSpacing: 10.h,
  //   //   ),
  //   //   controller: _controller,
  //   //   itemCount: foods.length + 1,
  //   //   itemBuilder: (_, index) {
  //   //     if (index == foods.length) {
  //   //       if (loading) {
  //   //         return SkeletonLoadingWidget(
  //   //           loading: loading,
  //   //           child: const WishlistItem(
  //   //             food: Product(
  //   //               id: 0,
  //   //               categoryId: 0,
  //   //               restaurantId: 0,
  //   //               name: '',
  //   //               description: '',
  //   //               images: [],
  //   //               price: 0,
  //   //               rate: 0,
  //   //               sale: 0,
  //   //               trending: false,
  //   //             ),
  //   //           ),
  //   //         );
  //   //       }

  //   //       if (error.isNotEmpty) {
  //   //         return CustomErrorWidget(
  //   //           error: error,
  //   //           type: errorType,
  //   //           onRetry: () => _load(),
  //   //         );
  //   //       }

  //   //       return const SizedBox.shrink();
  //   //     }
  //   //     return WishlistItem(food: foods[index]);
  //   //   },
  //   // );
  // }
}
