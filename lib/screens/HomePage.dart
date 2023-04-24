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
            drawer: const Drawer(child: SettingsDrawer()),
            drawerEnableOpenDragGesture: true,
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.homePageTitle),
              actions: [
                Switch(
                  value: appProvider.isDark,
                  onChanged: (value) {
                    appProvider.setColorMode(value);
                  },
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