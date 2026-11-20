// lib\Utils\AppLocaleController.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocaleController extends ChangeNotifier {
  static const String _localeKey = 'app_locale_code';
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_localeKey);
    if (saved == 'zh_Hant') {
      _locale = const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final code = newLocale.scriptCode == 'Hant' ? 'zh_Hant' : 'en';
    await prefs.setString(_localeKey, code);
  }
}