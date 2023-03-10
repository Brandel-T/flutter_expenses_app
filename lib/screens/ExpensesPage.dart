import 'package:expenses_app_2/components/BottomNavBar.dart';
import 'package:expenses_app_2/screens/expenses_page_tabs/ExpensesMonthTab.dart';
import 'package:expenses_app_2/screens/expenses_page_tabs/ExpensesWeekTab.dart';
import 'package:expenses_app_2/screens/expenses_page_tabs/ExpensesYearTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen>
    with SingleTickerProviderStateMixin {
  static const int _tabsLength = 3;

  late TabController tabController;

  List<Tab> _getTabs(BuildContext context) {
    return [
      Tab(text: AppLocalizations.of(context)!.week),
      Tab(text: AppLocalizations.of(context)!.month),
      Tab(text: AppLocalizations.of(context)!.year),
    ];
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: _tabsLength, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _getTabs(context).length,
      child: Builder(
        builder: (context) {
          TabController? tabController = DefaultTabController.of(context);

          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              print("Current tab index ${tabController.index}");
            }
          });

          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.expenses),
              bottom: TabBar(
                tabs: _getTabs(context),
              ),
            ),
            body: const TabBarView(
              children: [
                ExpensesWeekTab(),
                ExpensesMonthTab(),
                ExpensesYearTab(),
              ],
            ),
            bottomNavigationBar: const BottomNavBar(currentIndex: 1),
          );
        },
      ),
    );
  }
}
