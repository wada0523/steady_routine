import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steady_routine/navigation_service.dart';
import 'package:steady_routine/scene/onboarding/onboarding_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steady_routine/service/realm_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // ProviderScopeを配置
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final localeProvider =
    StateProvider<Locale>((ref) => AppLocalizations.supportedLocales.first);

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? locale;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();

    RealmService.realmInstance.initialize();
  }

  void setLocale(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }

  void _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedLanguageCode = prefs.getString('languageCode') ?? "ja";
    setState(() {
      locale = Locale(savedLanguageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('ja'),
        Locale('en'),
      ],
      locale: locale,
      home: const OnboardingScreen(),
    );
  }
}
