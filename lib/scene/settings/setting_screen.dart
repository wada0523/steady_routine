import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:steady_routine/providers/locale_provider.dart';
import 'package:steady_routine/util/admob.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerId = getAdBannerUnitId();
    BannerAd myBanner = BannerAd(
        adUnitId: bannerId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: const BannerAdListener());
    myBanner.load();

    final locale = ref.watch(localeNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xffC6C6C6),
            height: 1.0,
          ),
        ),
        flexibleSpace: Container(
          color: const Color(0xffffffff),
        ),
        title: Text(
          AppLocalizations.of(context)!.settings_title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Text(
                AppLocalizations.of(context)!.language_settings,
              ),
            ),
            const Spacer(),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  showCheckmark: false,
                  label: Text(
                    "日本語",
                    style: TextStyle(
                      color: locale.languageCode == "ja"
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: locale.languageCode == "ja",
                  selectedColor: const Color(0xfff88273),
                  backgroundColor: const Color(0xffececec),
                  onSelected: (_) {
                    ref
                        .read(localeNotifierProvider.notifier)
                        .setLocale(const Locale("ja"));
                  },
                ),
                ChoiceChip(
                  showCheckmark: false,
                  label: Text(
                    "English",
                    style: TextStyle(
                      color: locale.languageCode == "en"
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: locale.languageCode == "en",
                  selectedColor: const Color(0xfff88273),
                  backgroundColor: const Color(0xffececec),
                  onSelected: (_) {
                    ref
                        .read(localeNotifierProvider.notifier)
                        .setLocale(const Locale("en"));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: myBanner.size.width.toDouble(),
            height: myBanner.size.height.toDouble(),
            alignment: Alignment.center,
            child: AdWidget(ad: myBanner),
          ),
        ),
      ),
    );
  }
}
