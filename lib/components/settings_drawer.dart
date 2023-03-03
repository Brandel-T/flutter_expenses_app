import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../store/transaction_provider.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  bool _isDark = false;
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadColorMode();
    _loadLocale();
  }

  Future<void> _loadColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('isDark') ?? false;
    });
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locale = Locale(prefs.getString('languageCode') ?? 'en');
    });
  }

  Future<void> _switchColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = !(prefs.getBool('isDark') ?? false);
      prefs.setBool('isDark', _isDark);
    });
  }

  Future<void> _setLocale(Locale lc) async {
    if (!L10n.all.contains(lc)) {
      throw ArgumentError("language code ${lc.languageCode} is not supported for this application");
    }

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locale = lc;
      prefs.setString('languageCode', lc.languageCode);
    });
  }


  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<TransactionProvider>(context, listen: false);
    final language = appProvider.locale;

    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Center(
            child: Text("Expenses App", style: Theme.of(context).textTheme.headline3!,),
          ),
        ),
        Padding(padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appProvider.isDark ? AppLocalizations.of(context)!.darkMode : AppLocalizations.of(context)!.lightMode,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              GestureDetector(
                onTap: () {
                  appProvider.isDark = !appProvider.isDark;
                  _switchColorMode();
                },
                child: appProvider.isDark
                   ? const Icon(Icons.dark_mode_outlined)
                   : const Icon(Icons.light_mode_outlined),
                ///child: appProvider.isDark
                //                     ? const Icon(Icons.dark_mode_outlined)
                //                     : const Icon(Icons.light_mode_outlined),
              )
            ],
          ),
        ),
        Divider(color: Theme.of(context).colorScheme.onSurfaceVariant,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.language,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                value: language,
                items: L10n.all.map((locale) {
                  final countryName = L10n.getCountryName(locale.languageCode);

                  return DropdownMenuItem(
                    value: locale,
                    child: Text(countryName),
                    onTap: () {
                      appProvider.locale = locale;
                    },
                  );
                }).toList(),
                onChanged: (newLocale) {
                  _setLocale(newLocale!);
                  appProvider.locale = newLocale;
                },
              ),
            ],
          ),
        ),
        Divider(color: Theme.of(context).colorScheme.onSurfaceVariant,),
      ],
    );
  }
}
