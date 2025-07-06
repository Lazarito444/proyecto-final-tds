import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financia_mobile/config/app_preferences.dart';

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    _loadLocale();
    return null; // Usa el idioma del sistema por defecto
  }

  Future<void> _loadLocale() async {
    final langCode = await AppPreferences.getStringPreference('locale');
    if (langCode != null) {
      state = Locale(langCode);
    }
  }

  void setLocale(Locale locale) async {
    state = locale;
    await AppPreferences.setStringPreference('locale', locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  () => LocaleNotifier(),
);
