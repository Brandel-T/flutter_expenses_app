import 'package:flutter/material.dart';

class L10n {
  /// all supported languages of the app
  static final all = [
    const Locale('en'),
    const Locale('de', 'DE'),
    const Locale('fr', 'FR'),
  ];

  static String getCountryName(String? countryCode) {
    if (countryCode == 'de') return 'Deutsch';
    if (countryCode == 'fr') return 'Fran\u00e7ais';
    return 'English';
  }

  static Image getCountryFlag(String? countryCode) {
    String flag = "flag_UK";
    if (countryCode == 'de') flag = "flag_DE";
    if (countryCode == 'fr') flag = "flag_FR";
    return Image.asset('assets/images/$flag.png', width: 24, height: 24, fit: BoxFit.fitWidth);
  }
}
