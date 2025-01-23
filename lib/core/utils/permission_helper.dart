import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

final class PermissionHelper {
  const PermissionHelper._();

  static Future<bool> requestPermission(
    Permission permission, {
    VoidCallback? onError,
  }) async {
    PermissionStatus status = await permission.request();

    if (status.isDenied) {
      status = await permission.request();
      log(permission.toString());
      log(status.toString());
      if (status.isDenied) {
        onError?.call();
        return false;
      }
    }
    if (status.isPermanentlyDenied) {
      onError?.call();
      return false;
    }

    return status.isGranted;
  }
}
