import 'package:expenses_app_2/components/BottomNavBar.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../components/TransactionForm.dart';

class CalendarOverviewTab extends StatefulWidget {
  const CalendarOverviewTab({super.key, required this.imagePath, required this.setSelectedDay});

  final String imagePath;
  final Function setSelectedDay;

  @override
  State<CalendarOverviewTab> createState() => _CalendarOverviewTabState();
}

class _CalendarOverviewTabState extends State<CalendarOverviewTab> {
  DateTime?  _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;


  void addNewTransactionModal(BuildContext context, Function close) {
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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    void closeModal() {
      Navigator.of(context).pop();
    }

    return Scaffold(
      body: Consumer<TransactionProvider>(
        builder: (context, cameraStore, child) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: TableCalendar(
                    locale: Localizations.localeOf(context).languageCode,
                    focusedDay: _focusedDay,
                    firstDay: now,
                    lastDay: DateTime(now.year + 1),
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                        _selectedDay = selectedDay;
                        widget.setSelectedDay(_selectedDay);
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
                    onDayLongPressed: (selectedDay, focusedDay) => addNewTransactionModal(context, closeModal),
                    headerStyle: HeaderStyle(
                      titleTextStyle: Theme.of(context).textTheme.headlineMedium!,
                      formatButtonDecoration: BoxDecoration(border: Border.all(color: Colors.transparent),),
                      formatButtonTextStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w500, fontSize: 16)
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(weekdayStyle: Theme.of(context).textTheme.titleSmall!),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        onPressed: () => addNewTransactionModal(context, closeModal),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.surface,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
