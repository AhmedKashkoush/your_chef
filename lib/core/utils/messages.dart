import 'package:flutter/material.dart';
import 'package:your_chef/core/errors/error_types.dart';
import 'package:your_chef/core/extensions/space_extension.dart';

class AppMessages {
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
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
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
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
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
