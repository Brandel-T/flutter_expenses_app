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
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.indigo,
                Colors.indigo[400]!,
                const Color(0xff6a3de8),
                const Color(0xff6a3de8).withOpacity(0.99),
                const Color(0xff6a3de8).withOpacity(0.7),
                const Color(0x0ff536fe).withOpacity(0.3),
              ]
            ),
          ),
          child: Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: Image.asset('assets/logo/expenses.png')),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  return DropdownMenuItem(
                    value: locale,
                    child: Text(countryName),
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
