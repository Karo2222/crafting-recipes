import 'dart:io' show Platform;

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:craftingrecipes/main.dart';

/// Platform and layout helpers used across the app.
class DeviceInfo {
  DeviceInfo._();

  /// Minimum shortest side (in logical pixels) treated as a tablet.
  static const double _tabletBreakpoint = 600;

  static bool isDevice() => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static bool isDesktop() =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  static bool isMacOS() => !kIsWeb && Platform.isMacOS;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide > _tabletBreakpoint;

  static bool landscapeAllowed(BuildContext context) => isLargeScreen(context);

  /// True when a large screen is held in landscape and a two-pane layout fits.
  static bool inTabletLayout(BuildContext context) =>
      landscapeAllowed(context) &&
      MediaQuery.orientationOf(context) == Orientation.landscape;

  /// Returns a stable identifier for the current device, or null if the
  /// platform does not expose one.
  static Future<String?> getDeviceId() async {
    final plugin = DeviceInfoPlugin();
    String? id;
    try {
      if (kIsWeb) {
        final browser = await plugin.webBrowserInfo;
        id = [
          browser.vendor ?? '-',
          browser.userAgent ?? '-',
          '${browser.hardwareConcurrency}',
        ].join(' + ');
      } else if (Platform.isAndroid) {
        id = await const AndroidId().getId();
      } else if (Platform.isIOS) {
        id = (await plugin.iosInfo).identifierForVendor;
      } else if (Platform.isMacOS) {
        id = (await plugin.macOsInfo).systemGUID;
      } else if (Platform.isWindows) {
        id = (await plugin.windowsInfo).deviceId;
      } else if (Platform.isLinux) {
        id = (await plugin.linuxInfo).machineId;
      }
    } on PlatformException catch (error) {
      logger.e('Could not read the device id: $error');
    }
    logger.i('Device id: $id');
    return id;
  }
}
