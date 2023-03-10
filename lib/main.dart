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

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => TransactionProvider(),
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
  bool _isDark = false;
  String _localeLanguageCode = 'en';

  @override
  void initState() {
    super.initState();

    _loadSharedPreferencesData();
  }

  Future<void> _loadSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('isDark') ?? false;
      _localeLanguageCode = prefs.getString('languageCode') ?? 'en';
      debugPrint(">>>>>>>>>>>> shared preferences loaded (isDark: $_isDark)<<<<<<<<<<<<<<<");
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // i do not use 'listen: false' here because
    // i want to have this widget to be rebuilt
    final appProvider = Provider.of<TransactionProvider>(context);
    // appProvider.isDark = _isDark; // without notify listener
    // appProvider.locale = Locale(_localeLanguageCode); // without notify listener
  print("============= locale in main: $_localeLanguageCode ============");

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
      home: const HomePage(),
    );
  }
}
