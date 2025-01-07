import 'package:flutter/foundation.dart'; // for kReleaseMode
import 'package:liad/core/config/config_local_service.dart';
import 'package:liad/core/config/config_resources.dart';
import 'remote_config_service.dart';

class ConfigService {
  // Mendapatkan base URL
  static String get baseUrl {
    String baseUrl = kReleaseMode ? RemoteConfigService().baseUrl : ConfigLocalService.baseUrl;
    // ignore: avoid_print
    print('---------- Base URL---------');
    // ignore: avoid_print
    print(baseUrl);
    // ignore: avoid_print
    print('kReleaseMode : $kReleaseMode');
    return baseUrl;
  }
  // Mendapatkan session ID
  static String get applicationName {
    return kReleaseMode ? RemoteConfigService().applicationName : StringResources.nameApp;
  }
  static String get titleUpdateApp {
    return kReleaseMode ? RemoteConfigService().titleUpdateApp : StringResources.titleUpdateApp;
  }
  static String get subTitleUpdateApp {
    return kReleaseMode ? RemoteConfigService().subTitleUpdateApp : StringResources.subTitleUpdateApp;
  }
  static String get linkUpdateApp {
    return kReleaseMode ? RemoteConfigService().linkUpdateApp : StringResources.linkUpdateApp;
  }

  // Tambahkan getter lainnya sesuai kebutuhan Anda
  
}
