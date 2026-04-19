import 'package:flutter/material.dart';
import 'package:fair_share/services/language_service.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale;

  // Constructor that accepts an initial locale
  LocaleProvider(Locale? initialLocale)
    : _locale = initialLocale ?? const Locale('en');
  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    // Save to SharedPreferences so it persists
    LanguageService.saveLanguageCode(locale.languageCode);
    notifyListeners();
  }
}
