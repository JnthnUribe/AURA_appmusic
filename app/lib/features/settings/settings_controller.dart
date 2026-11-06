import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';

@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.normalizeVolume = true,
    this.wifiOnlyDownloads = true,
    this.showLyricsTranslation = false,
  });

  final ThemeMode themeMode;
  final bool normalizeVolume;
  final bool wifiOnlyDownloads;
  final bool showLyricsTranslation;

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? normalizeVolume,
    bool? wifiOnlyDownloads,
    bool? showLyricsTranslation,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      normalizeVolume: normalizeVolume ?? this.normalizeVolume,
      wifiOnlyDownloads: wifiOnlyDownloads ?? this.wifiOnlyDownloads,
      showLyricsTranslation:
          showLyricsTranslation ?? this.showLyricsTranslation,
    );
  }
}

class SettingsController extends Notifier<AppSettings> {
  static const _themeKey = 'settings.theme';
  static const _normalizeKey = 'settings.normalize_volume';
  static const _wifiKey = 'settings.wifi_only';
  static const _translationKey = 'settings.lyrics_translation';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  AppSettings build() {
    final themeName = _prefs.getString(_themeKey) ?? 'system';
    return AppSettings(
      themeMode: switch (themeName) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      },
      normalizeVolume: _prefs.getBool(_normalizeKey) ?? true,
      wifiOnlyDownloads: _prefs.getBool(_wifiKey) ?? true,
      showLyricsTranslation: _prefs.getBool(_translationKey) ?? false,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs.setString(_themeKey, mode.name);
  }

  Future<void> setNormalizeVolume(bool value) async {
    state = state.copyWith(normalizeVolume: value);
    await _prefs.setBool(_normalizeKey, value);
  }

  Future<void> setWifiOnlyDownloads(bool value) async {
    state = state.copyWith(wifiOnlyDownloads: value);
    await _prefs.setBool(_wifiKey, value);
  }

  Future<void> setLyricsTranslation(bool value) async {
    state = state.copyWith(showLyricsTranslation: value);
    await _prefs.setBool(_translationKey, value);
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
