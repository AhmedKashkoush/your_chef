import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:your_chef/core/constants/icons.dart';

class PizzaLoading extends StatefulWidget {
  final double? size;
  final Color? color;
  const PizzaLoading({super.key, this.size, this.color});

  @override
  State<PizzaLoading> createState() => _PizzaLoadingState();
}

class _PizzaLoadingState extends State<PizzaLoading>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotates;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    _rotates = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotates,
      child: SvgPicture.asset(
        AppIcons.pizza,
        colorFilter: ColorFilter.mode(
          widget.color ?? Colors.white,
          BlendMode.srcIn,
        ),
        width: widget.size?.w ?? 100.w,
        height: widget.size?.h ?? 100.h,
      ),
    );
  }
}
