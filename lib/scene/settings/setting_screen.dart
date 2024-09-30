import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:steady_routine/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  int _selectLocale = -1;

  @override
  void initState() {
    Future(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        var text = prefs.getString('languageCode') ?? "ja";
        if (text == "ja") {
          _selectLocale = 0;
        } else {
          _selectLocale = 1;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      color: _selectLocale == 0 ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: _selectLocale == 0,
                  selectedColor: const Color(0xfff88273),
                  backgroundColor: const Color(0xffececec),
                  onSelected: (_) {
                    setState(() {
                      _selectLocale = 0;
                      _changeLanguage(context, "ja");
                    });
                  },
                ),
                ChoiceChip(
                  showCheckmark: false,
                  label: Text(
                    "English",
                    style: TextStyle(
                      color: _selectLocale == 1 ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: _selectLocale == 1,
                  selectedColor: const Color(0xfff88273),
                  backgroundColor: const Color(0xffececec),
                  onSelected: (_) {
                    setState(() {
                      _selectLocale = 1;
                      _changeLanguage(context, "en");
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) async {
    Locale newLocale = Locale(languageCode);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    if (!context.mounted) return;
    MyApp.setLocale(context, newLocale);
  }
}
