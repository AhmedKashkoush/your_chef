import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/media_query_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/options/options.dart';
import 'package:your_chef/core/utils/network_helper.dart';
import 'package:your_chef/core/widgets/app_bars/custom_app_bar.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/wishlist/presentation/bloc/wishlist_bloc.dart';

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
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  void _load(BuildContext context) {
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
      context.read<WishlistBloc>().add(
            GetFoodsWishlistEvent(
              PaginationOptions(
                page: ++_page,
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
    context.read<WishlistBloc>().add(
          const GetFoodsWishlistEvent(
            PaginationOptions(),
          ),
        );
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
            appBar: CustomAppBar(
              profileTag: _tag,
            ),
            body: BlocConsumer<WishlistBloc, WishlistState>(
              listener: (context, state) {},
              builder: (context, state) {
                log('message');
                if (state.foods.isEmpty) {
                  if (state.status == RequestStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.status == RequestStatus.failure) {
                    return CustomErrorWidget(
                      error: state.error,
                      type: state.errorType,
                      onRetry: () => _load(context),
                    );
                  }
                }

                return RefreshIndicator.adaptive(
                  onRefresh: () => _refresh(context),
                  child: _buildGridView(
                    foods: state.foods,
                    error: state.status != RequestStatus.failure
                        ? ''
                        : state.error,
                    errorType: state.errorType,
                    loading: state.status == RequestStatus.loading,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridView({
    required List<Product> foods,
    bool loading = false,
    String error = '',
    ErrorType errorType = ErrorType.normal,
  }) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      controller: _controller,
      itemCount: foods.length + 1,
      itemBuilder: (_, index) {
        if (index == foods.length) {
          if (loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (error.isNotEmpty) {
            return CustomErrorWidget(
              error: error,
              type: errorType,
              onRetry: () => _load(context),
            );
          }

          return const SizedBox.shrink();
        }
        return Container(
          width: 40.w,
          height: 40.h,
          color: Colors.red,
        );
      },
    );
  }
}
