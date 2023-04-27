import 'package:expenses_app_2/screens/HomeScreen.dart';
import 'package:expenses_app_2/screens/transaction_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Localization imports
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './l10n/l10n.dart' as l10n;

// store
import 'package:expenses_app_2/store/transaction_provider.dart';

// theme import
import 'package:expenses_app_2/themes/app_theme.dart';

//components
import './screens/HomePage.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => TransactionProvider()
                                        ..loadColorMode()
                                        ..loadLocale()
                                        ..getAllTransactions(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, appProvider, child) {
        return MaterialApp(
          title: 'Expenses App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appProvider.isDark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          locale: appProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: l10n.L10n.all,
          home: const HomeScreen(),
          // home: const HomePage(),
          routes: {
            TransactionDetail.routeName: (context) => const TransactionDetail(),
          },
        );
      },
    );
  }
}
