import 'package:expenses_app_2/models/transaction_per_month.dart';
import 'package:expenses_app_2/models/transaction_per_week.dart';
import 'package:expenses_app_2/services/TransactionService.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import '../models/transaction.dart';
import '../l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction_per_year.dart';

class TransactionProvider extends ChangeNotifier {
  bool _isDark = false;
  Locale _locale = const Locale('en');
  List<Map<String, dynamic>> requestData = [];
  List<Transaction> transactions = [];
  List<MTransactionPerWeek> transactions_per_week = [];
  List<MTransactionPerMonth> transactions_per_month = [];
  List<MTransactionPerYear> transactions_per_year = [];

  bool get isDark => _isDark;

  set isDark(bool dm) {
    _isDark = dm;
    notifyListeners();
  }

  Locale get locale => _locale;

  set locale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  Future<void> loadPrefColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
  }

  Future<void> setPrefColorMode(bool colorMode) async {
    final prefs = await SharedPreferences.getInstance();
    isDark = colorMode;
    prefs.setBool('isDark', isDark);
  }

  void switchColorMode() {
    _isDark = !_isDark;
    notifyListeners();
  }

  Future<void> loadPrefLocale() async {
    final prefs = await SharedPreferences.getInstance();
    locale = Locale(prefs.getString('languageCode') ?? 'en');
  }

  Future<void> setPrefLocale(Locale lc) async {
    if (!L10n.all.contains(lc)) {
      throw ArgumentError("locale '${lc.languageCode} is not supported");
    }
    final prefs = await SharedPreferences.getInstance();
    locale = lc;
    prefs.setString('languageCode', locale.languageCode);
  }

/*
  Future<void> setLocale(String languageCode) async {
    if (!L10n.all.contains(Locale(languageCode))) {
      throw ArgumentError("language code $languageCode is not supported for this application");
    }

    final prefs = await SharedPreferences.getInstance();
    locale = Locale(languageCode);
    prefs.setString('languageCode', languageCode);
    notifyListeners();
  }
 */

/*
  Future<void> loadColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
    // notifyListeners(); // not necessary to define another one because it has been already defined in isDark setter
  }

  Future<void> switchColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = !(prefs.getBool('isDark') ?? false);
    prefs.setBool('isDark', isDark);
    // notifyListeners(); // not necessary to define another one because it has been already defined in isDark setter
  }

  void switchColorMode2()  {
    isDark = !isDark;
    notifyListeners();
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    locale = Locale(prefs.getString('languageCode') ?? 'en');
    // notifyListeners(); // not necessary to define another one because it has been already defined in locale setter
  }

  Future<void> setLocale(Locale lc) async {
    // checks if the given language code is supported by this
    // application (checks if defined in class lib/l10n/L10n.dart)
    if (!L10n.all.contains(lc)) {
      throw ArgumentError("language code ${lc.languageCode} is not supported for this application");
    }

    final prefs = await SharedPreferences.getInstance();
    locale = lc;
    prefs.setString('languageCode', lc.languageCode);
    // notifyListeners(); // not necessary to define another one because it has been already defined in locale setter
  }
 */

  /// *********************************
  /// transaction controller
  /// *********************************
  Future<void> getAllTransactions() async {
    requestData = await TransactionService.getAllTransactions();
    // notifyListeners();

    /**
     * transactions = data
        .map((tr) => Transaction(
        id: tr['id'],
        name: tr['name'],
        reason: tr['reason'],
        amount: tr['amount'],
        imagePath: tr['imagePath'],
        date: tr['date']))
        .toList();
        notifyListeners();
     */
  }

  Future<void> getAllWeekTransactions() async {
    requestData = await TransactionService.getAllTransactions();

    Map<int, List<Map<String, dynamic>>> trByWeek = {};

    for (final transaction in requestData) {
      final int calendarWeek = int.parse(transaction['calendar_week']);
      trByWeek.putIfAbsent(calendarWeek, () => []);
      trByWeek[calendarWeek]!.add(transaction);
    }

    transactions_per_week = trByWeek.entries.map((e) {
      double totalAmount = 0;
      for (final tr in e.value) {
        totalAmount += tr['amount'];
      }
      String startWeekDay = e.value.first['date'];
      return MTransactionPerWeek(
        calendarWeek: e.key,
        totalAmount: totalAmount,
        startWeekDay: startWeekDay,
        weekTransactions: e.value,
      );
    }).toList();

    notifyListeners();
  }

  Future<void> getAllMonthTransactions() async {
    requestData = await TransactionService.getAllTransactions();

    Map<int, List<Map<String, dynamic>>> trByMonth = {};

    for (final transaction in requestData) {
      final int calendarMonth = int.parse(transaction['calendar_month']);
      trByMonth.putIfAbsent(calendarMonth, () => []);
      trByMonth[calendarMonth]!.add(transaction);
    }

    transactions_per_month = trByMonth.entries.map((e) {
      double totalAmount = 0;
      for (final tr in e.value) {
        totalAmount += tr['amount'];
      }
      String startWeekDay = e.value.first['date'];
      return MTransactionPerMonth(
          calendarMonth: e.key,
          totalAmount: totalAmount,
          startMonthDay: startWeekDay,
          monthTransactions: e.value);
    }).toList();

    notifyListeners();
  }

  Future<void> getAllYearTransactions() async {
    requestData = await TransactionService.getAllTransactions();
    Map<int, List<Map<String, dynamic>>> trByYear = {};

    for (final transaction in requestData) {
      final int calendarYear = int.parse(transaction['calendar_year']);
      trByYear.putIfAbsent(calendarYear, () => []);
      trByYear[calendarYear]!.add(transaction);
    }

    transactions_per_year = trByYear.entries.map((e) {
      double totalAmount = 0;
      for (final tr in e.value) {
        totalAmount += tr['amount'];
      }

      String year = e.value.first['date'];

      return MTransactionPerYear(
        calendarYear: e.key,
        totalAmount: totalAmount,
        year: year,
        yearTransactions: e.value,
      );
    }).toList();

    notifyListeners();
  }

  void addTransaction(
    String id,
    String name,
    String reason,
    double amount,
    String imagePath,
    String date,
  ) {
    Transaction newTransaction = Transaction(
        id: id,
        name: name,
        reason: reason,
        amount: amount,
        imagePath: imagePath,
        date: date);
    transactions.add(newTransaction);

    try {
      TransactionService.insertTransaction(newTransaction);
      notifyListeners();
    } catch (e) {
      debugPrint('can not update in the db $e');
    }
  }

  void deleteTransaction(String id) {
    try {
      transactions.removeWhere((element) => element.id == id);
      TransactionService.deleteTransaction(id);
      notifyListeners();
    } catch (e) {
      debugPrint('can not delete from the db $e');
    }
  }

  void updateTransaction(String table, Transaction newTransactionData) {
    try {
      TransactionService.updateTransaction(newTransactionData);
      notifyListeners();
    } catch (e) {
      debugPrint('can not update in the db $e');
    }
  }
}
