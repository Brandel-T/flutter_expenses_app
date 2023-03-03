import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// To avoid repeating AppLocalizations.of(context) each time
AppLocalizations? t(BuildContext context) {
  return AppLocalizations.of(context);
}
