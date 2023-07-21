import 'package:expenses_app_2/screens/ExpensesPage.dart';
import 'package:expenses_app_2/screens/HomePage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/DashboardPage.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.edit_calendar_rounded),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.receipt_long_rounded),
          label: AppLocalizations.of(context)!.expenses,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bar_chart_rounded),
          label: AppLocalizations.of(context)!.dashboard,
        ),
      ],
      currentIndex: widget.currentIndex,
      elevation: 8,
      iconSize: 24.0,
      onTap: (screenIndex) async {
        switch (screenIndex) {
          case 0:
            if (widget.currentIndex != 0) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()),);
            }
            break;
          case 1:
            if (widget.currentIndex != 1) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ExpensesScreen()),);
            }
            break;
          case 2:
            if (widget.currentIndex != 2) {
              Navigator.of(context).push(MaterialPageRoute(
                   builder: (context) => const DashboardPage()),);
            }
            break;
        }
      },
    );
  }
}
