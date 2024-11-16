import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/layout/orientation_widget.dart';

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
    return SafeArea(
      child: Center(
        child: OrientationWidget(
          portrait: _CustomErrorWidgetPortrait(
            error: error,
            onRetry: onRetry,
            icon: _checkErrorType(),
          ),
          landscape: _CustomErrorWidgetLandscape(
            error: error,
            onRetry: onRetry,
            icon: _checkErrorType(),
          ),
        ),
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

class _CustomErrorWidgetPortrait extends StatelessWidget {
  final String error;
  final void Function() onRetry;
  final IconData icon;
  const _CustomErrorWidgetPortrait({
    required this.error,
    required this.onRetry,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 120,
          color: context.theme.iconTheme.color?.withOpacity(0.3),
        ),
        10.height,
        Text(
          error,
          style: TextStyle(
            fontSize: 20,
            color: context.theme.iconTheme.color?.withOpacity(0.3),
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
    );
  }
}

class _CustomErrorWidgetLandscape extends StatelessWidget {
  final String error;
  final void Function() onRetry;
  final IconData icon;
  const _CustomErrorWidgetLandscape({
    required this.error,
    required this.onRetry,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // const Spacer(),
        Icon(
          icon,
          size: 120,
          color: context.theme.iconTheme.color?.withOpacity(0.3),
        ),
        40.width,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error,
              style: TextStyle(
                fontSize: 20,
                color: context.theme.iconTheme.color?.withOpacity(0.3),
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
        // const Spacer(),
      ],
    );
  }
}
