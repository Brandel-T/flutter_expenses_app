import 'package:expenses_app_2/components/settings_drawer.dart';
import 'package:expenses_app_2/screens/home_page_tabs/CalendarOverviewTab.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/lang.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  String _uploadedBillImagePath = "";
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

  void _backToCalendarOverviewTab() {
    setState(() {
      print("tab index switched to home");
      _tabController.index = 1;
    });
  }

  void _useUploadedImage(String imagePath) {
    setState(() {
      _uploadedBillImagePath = imagePath;
    });
  }

  void _setSelectedDay(DateTime daySelected) {
    setState(() {
      _selectedDay = daySelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, tProvider, child) {
        return Scaffold(
          drawer: const Drawer(
            child: SettingsDrawer(),
          ),
          appBar: AppBar(
            title: Text( AppLocalizations.of(context)!.homePageTitle ),
            actions: [
              Switch(
                value: tProvider.isDark,
                onChanged: (value) {
                  tProvider.isDark = value;
                },
              )
            ],
          ),
          body: Column(
            children: [
              Flexible(
                child: CalendarOverviewTab(
                  imagePath: _uploadedBillImagePath,
                  setSelectedDay: _setSelectedDay,
                ),
              )
            ],
          )
        );
      },
    ) ;
  }
}
/*
Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Add a new transaction",
                      style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    GestureDetector(
                      onTap: () { tProvider.switchColorMode(); },
                      child: Container(
                        child: tProvider.isDark
                          ? const Icon(Icons.sunny)
                          : const Icon(Icons.dark_mode_outlined, size: 30, color: Colors.indigo,),
                      ),
                    ),
                  ],
                ),
              ),
 */
