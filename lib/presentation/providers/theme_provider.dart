import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// テーマモードの状態プロバイダー
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  static const String _key = 'theme_mode';

  // 保存されたテーマモードを読み込み
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_key);
    
    if (themeModeString != null) {
      switch (themeModeString) {
        case 'light':
          state = ThemeMode.light;
          break;
        case 'dark':
          state = ThemeMode.dark;
          break;
        case 'system':
        default:
          state = ThemeMode.system;
          break;
      }
    }
  }

  // テーマモードを変更して保存
  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, themeMode.name);
  }

  // ライトテーマに切り替え
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  // ダークテーマに切り替え
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  // システムテーマに切り替え
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  // テーマを切り替え（ライト ↔ ダーク）
  Future<void> toggleTheme() async {
    switch (state) {
      case ThemeMode.light:
        await setDarkTheme();
        break;
      case ThemeMode.dark:
        await setLightTheme();
        break;
      case ThemeMode.system:
        // システムテーマの場合は明示的にライトテーマに設定
        await setLightTheme();
        break;
    }
  }
}

// テーマプロバイダー
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// 現在のテーマがダークかどうかを判定するプロバイダー
final isDarkThemeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider);
  
  switch (themeMode) {
    case ThemeMode.dark:
      return true;
    case ThemeMode.light:
      return false;
    case ThemeMode.system:
      // システムの明るさを取得する必要があるが、
      // ここではMediaQueryが使えないので、デフォルトでfalse
      return false;
  }
});