import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/widgets/errors/custom_error_widget.dart';
import 'package:your_chef/core/widgets/loading/skeleton_loading_widget.dart';
import 'package:your_chef/features/home/domain/entities/product.dart';
import 'package:your_chef/features/wishlist/presentation/widgets/wishlist_item.dart';

class WishlistViewWidget extends StatelessWidget {
  final List<Product> foods;
  final bool loading;
  final String error;
  final ErrorType errorType;
  final ScrollController? controller;
  final VoidCallback? onRetry, onRefresh;
  const WishlistViewWidget({
    super.key,
    required this.foods,
    this.loading = false,
    this.error = '',
    this.errorType = ErrorType.normal,
    this.controller,
    this.onRetry,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => onRefresh?.call(),
      child: ListView.separated(
        controller: controller,
        padding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          top: 10.h,
          bottom: 80.h,
        ),
        itemBuilder: (_, index) {
          if (foods.isEmpty && loading) {
            return _buildLoading();
          }
          if (index == foods.length) {
            if (loading) {
              return _buildLoading();
            }

            if (error.isNotEmpty) {
              return CustomErrorWidget(
                error: error,
                type: errorType,
                onRetry: () => onRetry?.call(),
              );
            }

            return const SizedBox.shrink();
          }
          return WishlistItem(
            food: foods[index],
          );
        },
        separatorBuilder: (_, __) => 10.height,
        itemCount: foods.isEmpty && loading ? 10 : foods.length + 1,
      ),
    );
  }

  SkeletonLoadingWidget _buildLoading() {
    return SkeletonLoadingWidget(
      loading: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: double.infinity,
          height: 160.h,
          color: Colors.white,
        ),
      ),
    );
  }
}
