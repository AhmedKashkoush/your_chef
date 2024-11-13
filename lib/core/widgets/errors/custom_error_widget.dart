import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/space_extension.dart';

class CustomErrorWidget extends StatelessWidget {
  final String error;
  final ErrorType type;
  final void Function() onRetry;
  const CustomErrorWidget({
    super.key,
    required this.error,
    this.type = ErrorType.normal,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _checkErrorType(),
            size: 120,
            color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
          ),
          10.height,
          Text(
            error,
            style: TextStyle(
              fontSize: 20.sp,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
              fontWeight: FontWeight.bold,
            ),
          ),
          20.height,
          OutlinedButton.icon(
            onPressed: onRetry,
            label: const Text('Retry'),
            icon: const Icon(
              HugeIcons.strokeRoundedRefresh,
            ),
          )
        ],
      ),
    );
  }

  IconData _checkErrorType() {
    switch (type) {
      case ErrorType.network:
        return HugeIcons.strokeRoundedWifiDisconnected01;
      default:
        return HugeIcons.strokeRoundedAlert02;
    }
  }
}
