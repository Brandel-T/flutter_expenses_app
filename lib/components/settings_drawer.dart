import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../l10n/l10n.dart';
import '../store/transaction_provider.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<TransactionProvider>(context, listen: false);

    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Center(
            child: Text("Expenses App", style: Theme.of(context).textTheme.displaySmall!,),
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
                  appProvider.setColorMode(!appProvider.isDark);
                },
                child: appProvider.isDark
                   ? const Icon(Icons.dark_mode_outlined)
                   : const Icon(Icons.light_mode_outlined),
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
                value: appProvider.locale,
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                onChanged: (Locale? newLocale) {
                  appProvider.setLocale(newLocale ?? const Locale('en'));
                },
                items: L10n.all.map((locale) {
                  final countryName = L10n.getCountryName(locale.languageCode);
                  final countryFlag = L10n.getCountryFlag(locale.languageCode);
                  return DropdownMenuItem(
                    value: locale,
                    child: Row(
                      children: [
                        countryFlag,
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          child: Text(countryName),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Divider(color: Theme.of(context).colorScheme.onSurfaceVariant,),
      ],
    );
  }
}
