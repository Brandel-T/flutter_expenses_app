import 'package:expenses_app_2/screens/HomePage.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// custom theme
import '../themes/main.dart' as main;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Locale _currentLocale = const Locale('en');

  @override
  void initState() {
    _loadSharedPrefs();
    super.initState();
  }

  Future<void> _loadSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLocale = Locale(prefs.getString('languageCode') ?? 'en');
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<TransactionProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      drawerEnableOpenDragGesture: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Expanded(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(23),
                      bottomRight: Radius.circular(23),
                    ),
                    color: appProvider.isDark ? main.homePrimaryDark : main.homePrimaryLight,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: main.horizontalOffset),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: Text(AppLocalizations.of(context)!.home_screen_header_title, style: TextStyle(color: Colors.white.withOpacity(0.7)),)),
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: FutureBuilder(
                          future: appProvider.getTotalMonthAmount(),
                          initialData: "€0",
                          builder: (context, snapshot) =>
                              Text(NumberFormat.currency(symbol: "€", locale: appProvider.locale.countryCode).format(appProvider.totalMonthAmount), style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 40),)
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 20,
                  child: GestureDetector(
                    child: appProvider.isDark
                        ? Icon(Icons.light_mode_outlined, size: 40, color: Theme.of(context).indicatorColor,)
                        : Icon(Icons.dark_mode_outlined, size: 40, color: Theme.of(context).indicatorColor,),
                    onTap: () {
                      appProvider.setColorMode(!appProvider.isDark);
                    },
                  )
                ),
                FutureBuilder(
                  future: appProvider.getLastTransaction(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final lastTransaction = appProvider.lastTransaction;
                    return Positioned(
                      bottom: -60,
                      left: 0,
                      right: 0,
                      child: _transactionItem(
                        context,
                        date: DateFormat.yMEd(appProvider.locale.countryCode).format(DateTime.parse(lastTransaction?.date ?? "")),
                        name: "${lastTransaction?.name}",
                        amount: NumberFormat.currency(symbol: "€", locale: appProvider.locale.countryCode).format(lastTransaction?.amount ?? 0),
                        reason: lastTransaction?.reason,
                        color: appProvider.isDark
                            ? Theme.of(context).colorScheme.primary
                            : main.lastTransactionContainerBG
                      ),
                    );
                  },
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 75, left: 20, bottom: 10),
              child: Text(AppLocalizations.of(context)!.most_expensive_transactions,
                textAlign: TextAlign.left,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: appProvider.getLastMostExpensiveTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final lastTransactions = appProvider.lastMostExpensiveTransactions;
                  return lastTransactions.isEmpty
                      ? Text(AppLocalizations.of(context)!.no_entry)
                      : ListView.builder(
                    itemCount: lastTransactions.length,
                    itemBuilder: (context, index) {
                      return _transactionItem(
                          context,
                          date: DateFormat.yMEd(appProvider.locale.countryCode).format(DateTime.parse(lastTransactions[index].date)),
                          name: lastTransactions[index].name,
                          reason: lastTransactions[index].reason,
                          amount: NumberFormat.currency(symbol: "€", locale: appProvider.locale.countryCode).format(lastTransactions[index].amount)
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const HomePage(),)
          );
        },
        label: Text(AppLocalizations.of(context)!.next),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }

  Widget _transactionItem(
    BuildContext context, {
    required String date,
    required String name,
    String? reason,
    required String amount,
    Color? color,
  }) {
    return Container(
      height: main.transactionHeight,
      width: double.infinity,
      margin: const EdgeInsets.only(left: main.horizontalOffset, right: main.horizontalOffset, bottom: main.verticalOffset),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(main.transactionRadius),
        color: color ?? Theme.of(context).colorScheme.surface.withOpacity(0.7),
        boxShadow: const [
          main.boxShadow
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: Text(date, style: TextStyle(color: Theme.of(context).hintColor, fontSize: 11),)),
                Expanded(child: Text(name, style: Theme.of(context).textTheme.titleMedium,)),
                Flexible(fit: FlexFit.tight, child: Text(reason!, style: Theme.of(context).textTheme.bodyMedium,)),
              ],
            ),
          ),
          Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Text(amount, style: const TextStyle(color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.w400),))
        ],
      ),
    );
  }
}