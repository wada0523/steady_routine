import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  static const String _kLanguageCode = 'languageCode';

  @override
  Locale build() {
    _loadLocale();
    return const Locale('en');
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String languageCode = prefs.getString(_kLanguageCode) ?? 'ja';
    state = Locale(languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    if (!['ja', 'en'].contains(locale.languageCode)) return;
    state = locale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguageCode, locale.languageCode);
  }
}
