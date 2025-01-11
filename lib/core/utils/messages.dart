import 'package:flutter/material.dart';
import 'package:your_chef/core/constants/colors.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/navigation_extension.dart';
import 'package:your_chef/core/extensions/space_extension.dart';
import 'package:your_chef/core/extensions/theme_extension.dart';
import 'package:your_chef/core/widgets/loading/pizza_loading.dart';

class AppMessages {
  const AppMessages._();
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String message,
    Widget? content,
    bool confirmIsDanger = false,
    bool cancelIsDanger = false,
  }) {
    return showDialog<bool?>(
      context: context,
      builder: (_) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              context.pop(true);
            },
            child: Text(
              'Yes',
              style: TextStyle(
                color: confirmIsDanger ? Colors.red : null,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop(false);
            },
            child: Text(
              'No',
              style: TextStyle(
                color: cancelIsDanger ? Colors.red : null,
              ),
            ),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (content != null) ...[10.height, content],
          ],
        ),
      ),
    );
  }

  static void showLoadingDialog(
    BuildContext context, {
    required String message,
    bool usePizza = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              usePizza
                  ? const PizzaLoading()
                  : const CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
              10.height,
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showSuccessMessage(BuildContext context, String message,
      [bool cancelPrevious = true]) {
    if (cancelPrevious) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check,
              color: Colors.white,
            ),
            10.width,
            Expanded(
              child: Text(
                message,
                style: context.theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Colors.green,
      ),
    );
  }

  static void showErrorMessage(BuildContext context, String message,
      [ErrorType type = ErrorType.normal, bool cancelPrevious = true]) {
    if (cancelPrevious) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (type == ErrorType.network)
              const Icon(
                Icons.wifi_off,
                color: Colors.white,
              )
            else if (type == ErrorType.auth)
              const Icon(
                Icons.person,
                color: Colors.white,
              )
            else if (type == ErrorType.normal)
              const Icon(
                Icons.warning_rounded,
                color: Colors.white,
              ),
            10.width,
            Expanded(
              child: Text(
                message,
                style: context.theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Colors.red,
      ),
    );
  }
}
