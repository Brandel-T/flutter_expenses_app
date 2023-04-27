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
import '../models/transaction_amount_grouped_data.dart';

class TransactionProvider extends ChangeNotifier {
  bool _isDark = false;
  Locale _locale = const Locale('en');

  List<Map<String, dynamic>> requestData = [];
  List<Transaction> transactions = [];
  List<MTransactionPerWeek> transactions_per_week = [];
  List<MTransactionPerMonth> transactions_per_month = [];
  List<MTransactionPerYear> transactions_per_year = [];
  List<MTransactionGroupedAmountData> maxAmountPerMonth = [];
  List<MTransactionGroupedAmountData> maxAmountPerWeek = [];
  List<Transaction> lastMostExpensiveTransactions = [];
  Transaction? lastTransaction;
  double totalMonthAmount = 0;

  bool get isDark => _isDark;

  set isDark(bool dm) {
    _isDark = dm;
    notifyListeners();
  }

  Locale get locale => _locale;

  set locale(Locale locale) {
    _locale = !L10n.all.contains(locale) ? const Locale('en') : locale;
    notifyListeners();
  }

  void loadColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
  }

 void loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    locale = Locale(prefs.getString('languageCode') ?? 'en');
  }

  Future<void> loadPrefColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
  }

  Future<void> setPrefColorMode(bool darkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', darkMode);
  }

  void setColorMode(bool isDark) {
    this.isDark = isDark;
    setPrefColorMode(isDark);
  }

  void switchColorMode() async {
    _isDark = !_isDark;
    notifyListeners();
  }

  Future<void> setPrefLocale(Locale lc) async {
    final prefs = await SharedPreferences.getInstance();
    if (!L10n.all.contains(lc)) {
      prefs.setString('languageCode', 'en');
    } else {
      prefs.setString('languageCode', locale.languageCode);
    }
  }

  void setLocale(Locale otherLocale) {
    setPrefLocale(otherLocale);
    locale = otherLocale;
  }

  Future<void> getAllTransactions() async {
    requestData = await TransactionService.getAllTransactions();
    for (final tr in requestData) {
      transactions.add(Transaction(
          id: tr['id'],
          name: tr['name'],
          reason: tr['reason'],
          amount: tr['amount'],
          imagePath: tr['imagePath'],
          date: tr['date'],
        )
      );
    }
    notifyListeners();
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

  Future<void> getLastMostExpensiveTransactions() async {
    final response = await TransactionService.getMostExpensiveTransactionOfMonth();
    lastMostExpensiveTransactions = [];
    for (var tr in response) {
      lastMostExpensiveTransactions.add(Transaction(
          id: tr['id'],
          name: tr['name'],
          reason: tr['reason'],
          amount: tr['amount'],
          imagePath: tr['imagePath'],
          date: tr['date']
      ));
    }
    notifyListeners();
  }

  Future<void> getTotalMonthAmount() async {
    final response = await TransactionService.getTotalAmountOfMonth();
    totalMonthAmount = response[0]['total_month_amount'];
    notifyListeners();
  }

  Future<void> getLastTransaction() async {
    final response = await TransactionService.getLastTransaction();
    lastTransaction = Transaction(
      id: response[0]['id'],
      name: response[0]['name'],
      reason: response[0]['reason'],
      amount: response[0]['amount'],
      imagePath: response[0]['imagePath'],
      date: response[0]['date']
    );
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
    getAllWeekTransactions();
    getAllMonthTransactions();
    getAllYearTransactions();

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
      getAllWeekTransactions();
      getAllMonthTransactions();
      getAllYearTransactions();
    } catch (e) {
      debugPrint('can not delete from the db $e');
    }
  }

  void updateTransaction(String table, Transaction newTransactionData) {
    try {
      TransactionService.updateTransaction(newTransactionData);
      notifyListeners();
      getAllWeekTransactions();
      getAllMonthTransactions();
      getAllYearTransactions();
    } catch (e) {
      debugPrint('can not update in the db $e');
    }
  }

  Future<void> getMaxAmountPerMonth() async {
    List<Map<String, dynamic>> data = await TransactionService.findMaxAmountPerMonth();
    maxAmountPerMonth = [];
    for (int i = 0; i < data.length; ++i) {
      MTransactionGroupedAmountData value = MTransactionGroupedAmountData(
        periodDate: data[i]['month'],
        periodAmount: data[i]['month_total_amount'],
      );
      maxAmountPerMonth.add(value);
    }
    maxAmountPerMonth.sort((a, b) => a.compareTo(b)); // ! IMPORTANT
  }
}
