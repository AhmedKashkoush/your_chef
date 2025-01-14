part of '../../screens/explore_foods_screen.dart';

class CategoriesTabBar extends StatelessWidget {
  const CategoriesTabBar(
      {super.key,
      required TabController controller,
      required List<Category> categories})
      : _controller = controller,
        _categories = categories;

  final TabController _controller;
  final List<Category> _categories;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24.r),
      ),
      labelColor: Colors.white,
      unselectedLabelColor: context.theme.iconTheme.color?.withOpacity(0.5),
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      controller: _controller,
      tabs: _categories
          .map((category) => Tab(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
                  child: Row(
                    children: [
                      if (category.image.isNotEmpty) ...[
                        Image.asset(
                          category.image,
                          width: 20.w,
                        ),
                        10.width,
                      ],
                      Text(category.name.tr()),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
