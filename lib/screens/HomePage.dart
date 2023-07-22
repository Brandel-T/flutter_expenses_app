import 'package:expenses_app_2/components/BottomNavBar.dart';
import 'package:expenses_app_2/components/settings_drawer.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/TransactionForm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  DateTime? _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          drawer: const Drawer(child: SettingsDrawer()),
          drawerEnableOpenDragGesture: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: 250,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Image.asset('assets/images/buy-online.gif'),
                  ),
                ),
                title: Text(AppLocalizations.of(context)!.transaction, style: TextStyle(color: Theme.of(context).indicatorColor),),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        appProvider.setColorMode(!appProvider.isDark);
                      },
                      child: appProvider.isDark
                          ? const Icon(Icons.dark_mode_outlined)
                          : Icon(Icons.light_mode_outlined, color: Theme.of(context).indicatorColor),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(child: _getCalendar()),
            ]
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 4,
            onPressed: () => _addNewTransactionModal(context, _closeModal),
            backgroundColor: Theme.of(context).indicatorColor,
            foregroundColor: Theme.of(context).colorScheme.surface,
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: const BottomNavBar(currentIndex: 0),
        );
      },
    );
  }
  
  void _closeModal() {
    Navigator.of(context).pop();
  }

  void _addNewTransactionModal(BuildContext context, Function close) {
    showModalBottomSheet(
      context: context,
      elevation: 4,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: TransactionForm(
            selectedDay: _selectedDay,
            closeModal: close,
          ),
        );
      },
    );
  }

  Widget _getCalendar() {
    DateTime now = DateTime.now();

    return Consumer<TransactionProvider>(
        builder: (context, cameraStore, child) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: TableCalendar(
              locale: Localizations.localeOf(context).languageCode,
              focusedDay: _focusedDay,
              firstDay: DateTime(now.year-1),
              lastDay: DateTime(now.year + 1),
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedDay = selectedDay;
                });
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {_focusedDay = focusedDay;},
              startingDayOfWeek: StartingDayOfWeek.monday,
              shouldFillViewport: true,
              onDayLongPressed: (selectedDay, focusedDay) => _addNewTransactionModal(context, _closeModal),
              headerStyle: HeaderStyle(
                titleTextStyle: Theme.of(context).textTheme.headlineMedium!,
                formatButtonDecoration: BoxDecoration(border: Border.all(color: Colors.transparent),),
                formatButtonTextStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w500, fontSize: 16)
              ),
              daysOfWeekStyle: DaysOfWeekStyle(weekdayStyle: Theme.of(context).textTheme.titleSmall!),
            ),
          );
        },
      );
  }
}