import 'package:firebase_remote_config/firebase_remote_config.dart'; // Import ini penting!

class RemoteConfigService {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  // Singleton pattern to ensure one instance of RemoteConfigService
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  factory RemoteConfigService() {
    return _instance;
  }

  RemoteConfigService._internal();

  Future<void> initConfig() async {
    try {
      // Set default values for Remote Config
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          // ini waktu untuk get ulang data firebase
          minimumFetchInterval: const Duration(minutes: 1),
        ),
      );

      // Fetch and activate remote config values
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching Remote Config: $e');
    }
  }

  // cara memanggilnya
  /*
  String applicationName = RemoteConfigService().applicationName;
  */

  String get applicationName => _remoteConfig.getString('application_name');
  String get baseUrl => _remoteConfig.getString('base_url');
  String get version => _remoteConfig.getString('version');
  String get titleUpdateApp => _remoteConfig.getString('title_update_app');
  String get subTitleUpdateApp => _remoteConfig.getString('subtitle_update_app');
  String get linkUpdateApp => _remoteConfig.getString('link_update_apps');
}

