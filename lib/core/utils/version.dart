import 'package:package_info_plus/package_info_plus.dart';

Future<String> getAppVersion() async {
  try {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version} (${packageInfo.buildNumber})';
  } catch (e) {
    return 'Failed to get app version';
  }
}

Future<String> getVersion() async {
  try {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  } catch (e) {
    return 'Failed to get app version';
  }
}
