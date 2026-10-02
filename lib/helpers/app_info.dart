import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import 'package:craftingrecipes/helpers/device_info.dart';

/// Name, version and device id shown on the settings page.
class AppInfo {
  const AppInfo({
    required this.name,
    required this.version,
    required this.deviceID,
  });

  final String name;
  final String version;
  final String deviceID;
}

/// Reads name and version from the bundled pubspec and adds the device id.
Future<AppInfo> appInformation() async {
  final pubspec = loadYaml(await rootBundle.loadString('pubspec.yaml')) as Map;
  return AppInfo(
    name: '${pubspec['name']}',
    version: '${pubspec['version']}',
    deviceID: await DeviceInfo.getDeviceId() ?? '',
  );
}
