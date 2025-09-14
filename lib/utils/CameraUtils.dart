import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraUtils {
  /// Checks and requests camera permissions.
  /// Returns true if both permissions are granted, false otherwise.
  static Future<bool> checkCameraPermissions(BuildContext context) async {
    // Check camera permission
    PermissionStatus cameraPermission = await Permission.camera.status;
    if (cameraPermission.isDenied) {
      cameraPermission = await Permission.camera.request();
      if (cameraPermission.isDenied) {
        return false;
      }
    }
    if (cameraPermission.isPermanentlyDenied) {
      return false;
    }

    return true;
  }
}
