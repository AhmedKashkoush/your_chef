part of '../../screens/explore_foods_screen.dart';

class FoodView extends StatefulWidget {
  final Category category;
  const FoodView({
    super.key,
    required this.category,
  });

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetExploreFoodsBloc, GetExploreFoodsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == RequestStatus.failure) {
          AppMessages.showErrorMessage(context, state.error, state.errorType);
        }
      },
      builder: (context, state) {
        if (state.foods.isEmpty) {
          if (state.status == RequestStatus.failure) {
            return CustomErrorWidget(
              error: state.error,
              type: state.errorType,
              onRetry: () => context.read<GetExploreFoodsBloc>().add(
                    _getExploreFoodsEvent(),
                  ),
            );
          }

          if (state.status == RequestStatus.success) {
            const SizedBox.shrink();
          }
        }
        return SkeletonLoadingWidget(
          loading: state.status == RequestStatus.loading && state.foods.isEmpty,
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => await _refresh(context),
            child: state.foods.isEmpty && state.status == RequestStatus.loading
                ? _buildGridView(
                    loading: state.status == RequestStatus.loading,
                    foods: _loadingList,
                  )
                : _buildGridView(
                    loading: state.status == RequestStatus.loading,
                    foods: state.foods,
                  ),
          ),
        );
      },
    );
  }

  List<Food> get _loadingList =>
      List.generate(20, (index) => AppDummies.foods.first.toEntity());

  GridView _buildGridView({required List<Food> foods, required bool loading}) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0).r,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
      ),
      controller: _scrollController,
      itemCount: foods.length +
          (loading
              ? foods.length % 2 == 0
                  ? 2
                  : 1
              : 0),
      itemBuilder: (_, index) {
        if (index > foods.length - 1) {
          if (loading) {
            return SkeletonLoadingWidget(
              loading: true,
              child: FoodItem(
                food: AppDummies.foods.first.toEntity(),
              ),
            );
          }
          return const SizedBox.shrink();
        }
        return FoodItem(
          food: foods[index],
        );
      },
    );
  }

  Future<void> _refresh(BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    if (!context.mounted) return;
    context
        .read<GetExploreFoodsBloc>()
        .add(const GetExploreRefreshFoodsEvent());
    context.read<GetExploreFoodsBloc>().add(_getExploreFoodsEvent());
  }

  GetExploreFoodsEvent _getExploreFoodsEvent({int? page}) {
    if (widget.category.name.toLowerCase() ==
        AppStrings.popularFoods.toLowerCase()) {
      return GetExplorePopularFoodsEvent(
        PaginationOptions(
          limit: 12,
          page: page ?? 1,
        ),
      );
    }
    if (widget.category.name.toLowerCase() ==
        AppStrings.onASale.toLowerCase()) {
      return GetExploreOnASaleFoodsEvent(
        PaginationOptions(
          limit: 12,
          page: page ?? 1,
        ),
      );
    }
    return GetExploreFoodsByCategoryEvent(
      PaginationOptions<Category>(
        limit: 12,
        page: page ?? 1,
        model: widget.category,
      ),
    );
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      if (context.read<GetExploreFoodsBloc>().state.end) return;
      context.read<GetExploreFoodsBloc>().add(_getExploreFoodsEvent(
            page: context.read<GetExploreFoodsBloc>().state.page,
          ));
    }
  }
}
