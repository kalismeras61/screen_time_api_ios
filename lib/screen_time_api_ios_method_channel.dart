import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_time_api_ios_platform_interface.dart';

/// An implementation of [ScreenTimeApiIosPlatform] that uses method channels.
class MethodChannelScreenTimeApiIos extends ScreenTimeApiIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_time_api_ios');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> selectAppsToDiscourage() async {
    await methodChannel.invokeMethod('selectAppsToDiscourage');
  }

  @override
  Future<void> encourageAll() async {
    await methodChannel.invokeMethod('encourageAll');
  }

  @override
  Future<void> disallowApps(List<String> bundleIdentifiers) async {
    await methodChannel.invokeMethod('disallowApps', bundleIdentifiers);
  }

  @override
  Future<void> addDisallowedApps(List<String> bundleIdentifiers) async {
    await methodChannel.invokeMethod('addDisallowedApps', bundleIdentifiers);
  }

  @override
  Future<void> removeDisallowedApps(List<String> bundleIdentifiers) async {
    await methodChannel.invokeMethod('removeDisallowedApps', bundleIdentifiers);
  }
}
