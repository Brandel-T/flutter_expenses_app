import 'package:expenses_app_2/components/settings_drawer.dart';
import 'package:expenses_app_2/screens/home_page_tabs/CalendarOverviewTab.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String _uploadedBillImagePath = "";
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setSelectedDay(DateTime daySelected) {
    setState(() {
      _selectedDay = daySelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
            drawer: const Drawer(child: SettingsDrawer(),),
            drawerEnableOpenDragGesture: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(AppLocalizations.of(context)!.homePageTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
              actions: [
                GestureDetector(
                  onTap: () {
                    appProvider.setColorMode(!appProvider.isDark);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: appProvider.isDark
                        ? const Icon(Icons.dark_mode_outlined)
                        : Icon(Icons.light_mode_outlined, color: Theme.of(context).colorScheme.onSurface,),
                  )
                )
              ],
            ),
            body: Column(
              children: [
                Image.asset('assets/images/buy-online.gif', height: 250),
                Flexible(
                  child: CalendarOverviewTab(
                    imagePath: _uploadedBillImagePath,
                    setSelectedDay: _setSelectedDay,
                  ),
                )
              ],
            ),
        );
      },
    );
  }
}