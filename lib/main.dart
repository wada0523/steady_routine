import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steady_routine/navigation_service.dart';
import 'package:steady_routine/scene/home/home_screen.dart';
import 'package:steady_routine/scene/onboarding/onboarding_screen.dart';
import 'package:steady_routine/service/realm_service.dart';
import 'package:steady_routine/providers/locale_provider.dart';
import 'package:steady_routine/util/admob.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    // 初回起動の場合は、フラグをfalseに更新
    await prefs.setBool('isFirstLaunch', false);
  }

  runApp(
    ProviderScope(
      child: MyApp(isFirstLaunch: isFirstLaunch),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);

    useEffect(
      () {
        () async {
          RealmService.realmInstance.initialize();
        }();
        return null;
      },
      [],
    );

    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('ja'),
        Locale('en'),
      ],
      locale: locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return supportedLocales.first;
        }
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: isFirstLaunch ? const OnboardingScreen() : HomeScreen(),
    );
  }
}
