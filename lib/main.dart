import 'package:expenses_app_2/screens/HomeScreen.dart';
import 'package:expenses_app_2/screens/transaction_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Localization imports
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './l10n/l10n.dart' as l10n;

// store
import 'package:expenses_app_2/store/transaction_provider.dart';

// theme import
import 'package:expenses_app_2/themes/app_theme.dart';

//components
import './screens/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool darkMode = prefs.getBool('isDark') ?? false;
  Locale currentLocale = Locale(prefs.getString('languageCode') ?? 'en');

  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => TransactionProvider(),
      child:  MyApp(darkMode: darkMode, currentLocale: currentLocale),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool darkMode;
  final Locale currentLocale;
  const MyApp({super.key, required this.darkMode, required this.currentLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;
  Locale _currentLocale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadSharedPrefs();
  }

  Future<void> _loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('isDark') ?? false;
      _currentLocale = Locale(prefs.getString('languageCode') ?? 'en');
    });
  }

  @override
  Widget build(BuildContext context) {
    final noListeningProvider = Provider.of<TransactionProvider>(context, listen: false);

    return Consumer<TransactionProvider>(
      builder: (context, appProvider, child) {
        return MaterialApp(
          title: 'Expenses App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appProvider.isDark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          locale: noListeningProvider.locale,
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
