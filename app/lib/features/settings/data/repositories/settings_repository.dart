import 'package:bang_navigator/features/content_block/data/models/host.dart';
import 'package:bang_navigator/features/settings/data/models/settings.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_repository.g.dart';

typedef UpdateSettingsFunc = Settings Function(Settings currentSettings);

Set<HostSource>? _parseHostSources(List<String>? input) => input
    ?.map(
      (list) =>
          HostSource.values.firstWhereOrNull((source) => source.name == list),
    )
    .whereNotNull()
    .toSet();

ThemeMode? _parseThemeMode(int? index) {
  if (index != null && index < ThemeMode.values.length) {
    return ThemeMode.values[index];
  }

  return null;
}

@Riverpod(keepAlive: true)
class SettingsRepository extends _$SettingsRepository {
  static const _sessionStorageKey = 'b4ng_kagi_session';
  static const _showEarlyAccessFeaturesKey = 'b4ng_show_early_access';
  static const _incognitoStorageKey = 'b4ng_settings_incognito';
  static const _javascriptStorageKey = 'b4ng_settings_js';
  static const _launchExternalStorageKey = 'b4ng_settings_launch_external';
  static const _contentBlockingStorageKey = 'b4ng_settings_content_blocking';
  static const _blockHttpProtocolStorageKey = 'b4ng_settings_block_http';
  static const _enableHostListStorageKey = 'b4ng_settings_host_lists';
  static const _themeModeStorageKey = 'b4ng_settings_theme_mode';

  final FlutterSecureStorage _flutterSecureStorage;
  final Future<SharedPreferences> _sharedPreferences;

  SettingsRepository()
      : _flutterSecureStorage = const FlutterSecureStorage(),
        _sharedPreferences = SharedPreferences.getInstance();

  Future<void> updateSettings(UpdateSettingsFunc updateWithCurrent) async {
    final sharedPreferences = await _sharedPreferences;
    final oldSettings = state.value!;
    final newSettings = updateWithCurrent(oldSettings);

    if (oldSettings != newSettings) {
      if (oldSettings.kagiSession != newSettings.kagiSession) {
        await _flutterSecureStorage.write(
          key: _sessionStorageKey,
          value: (newSettings.kagiSession?.isNotEmpty ?? false)
              ? newSettings.kagiSession
              : null,
        );
      }

      if (newSettings.showEarlyAccessFeatures !=
          oldSettings.showEarlyAccessFeatures) {
        await sharedPreferences.setBool(
          _showEarlyAccessFeaturesKey,
          newSettings.showEarlyAccessFeatures,
        );
      }

      if (newSettings.incognitoMode != oldSettings.incognitoMode) {
        await sharedPreferences.setBool(
          _incognitoStorageKey,
          newSettings.incognitoMode,
        );
      }

      if (newSettings.enableJavascript != oldSettings.enableJavascript) {
        await sharedPreferences.setBool(
          _javascriptStorageKey,
          newSettings.enableJavascript,
        );
      }

      if (newSettings.launchUrlExternal != oldSettings.launchUrlExternal) {
        await sharedPreferences.setBool(
          _launchExternalStorageKey,
          newSettings.launchUrlExternal,
        );
      }

      if (newSettings.enableContentBlocking !=
          oldSettings.enableContentBlocking) {
        await sharedPreferences.setBool(
          _contentBlockingStorageKey,
          newSettings.enableContentBlocking,
        );
      }

      if (newSettings.blockHttpProtocol != oldSettings.blockHttpProtocol) {
        await sharedPreferences.setBool(
          _blockHttpProtocolStorageKey,
          newSettings.blockHttpProtocol,
        );
      }

      if (!const DeepCollectionEquality.unordered().equals(
        newSettings.enableHostList,
        oldSettings.enableHostList,
      )) {
        await sharedPreferences.setStringList(
          _enableHostListStorageKey,
          newSettings.enableHostList.map((list) => list.name).toList(),
        );
      }

      if (newSettings.themeMode != oldSettings.themeMode) {
        await sharedPreferences.setInt(
          _themeModeStorageKey,
          newSettings.themeMode.index,
        );
      }

      ref.invalidateSelf();
    }
  }

  @override
  FutureOr<Settings> build() async {
    final sharedPreferences = await _sharedPreferences;

    return Settings.withDefaults(
      kagiSession: await _flutterSecureStorage.read(key: _sessionStorageKey),
      showEarlyAccessFeatures:
          sharedPreferences.getBool(_showEarlyAccessFeaturesKey),
      incognitoMode: sharedPreferences.getBool(_incognitoStorageKey),
      enableJavascript: sharedPreferences.getBool(_javascriptStorageKey),
      launchUrlExternal: sharedPreferences.getBool(_launchExternalStorageKey),
      enableContentBlocking:
          sharedPreferences.getBool(_contentBlockingStorageKey),
      blockHttpProtocol:
          sharedPreferences.getBool(_blockHttpProtocolStorageKey),
      enableHostList: _parseHostSources(
        sharedPreferences.getStringList(_enableHostListStorageKey),
      ),
      themeMode:
          _parseThemeMode(sharedPreferences.getInt(_themeModeStorageKey)),
    );
  }
}
