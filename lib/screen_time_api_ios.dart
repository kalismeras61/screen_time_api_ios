import 'screen_time_api_ios_platform_interface.dart';
import 'screen_time_api_ios_method_channel.dart';

class ScreenTimeApiIos {
  Future<String?> getPlatformVersion() {
    return ScreenTimeApiIosPlatform.instance.getPlatformVersion();
  }

  Future selectAppsToDiscourage() async {
    final instance = ScreenTimeApiIosPlatform.instance as MethodChannelScreenTimeApiIos;
    await instance.selectAppsToDiscourage();
  }

  Future encourageAll() async {
    final instance = ScreenTimeApiIosPlatform.instance as MethodChannelScreenTimeApiIos;
    await instance.encourageAll();
  }

  Future disallowApps(List<String> bundleIdentifiers) async {
    final instance = ScreenTimeApiIosPlatform.instance as MethodChannelScreenTimeApiIos;
    await instance.disallowApps(bundleIdentifiers);
  }

  Future addDisallowedApps(List<String> bundleIdentifiers) async {
    final instance = ScreenTimeApiIosPlatform.instance as MethodChannelScreenTimeApiIos;
    await instance.addDisallowedApps(bundleIdentifiers);
  }

  Future removeDisallowedApps(List<String> bundleIdentifiers) async {
    final instance = ScreenTimeApiIosPlatform.instance as MethodChannelScreenTimeApiIos;
    await instance.removeDisallowedApps(bundleIdentifiers);
  }
}
