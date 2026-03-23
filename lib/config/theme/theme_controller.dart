import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'theme_mode';

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  ThemeMode get currentTheme => themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  // 🔥 Load saved theme
  Future<void> _loadThemeFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);

    if (savedTheme == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.system;
    }

    Get.changeThemeMode(themeMode.value);
  }

  // 🔥 Save theme
  Future<void> _saveThemeToStorage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, value);
  }

  // Toggle theme
  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  // Set specific theme
  void setTheme(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);

    // Save locally
    if (mode == ThemeMode.dark) {
      _saveThemeToStorage('dark');
    } else if (mode == ThemeMode.light) {
      _saveThemeToStorage('light');
    } else {
      _saveThemeToStorage('system');
    }
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;
}