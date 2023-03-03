import 'package:expenses_app_2/services/TransactionService.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import '../models/transaction.dart';
import '../l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionProvider extends ChangeNotifier {
  bool _isDark = false;
  Locale _locale = const Locale('en');
  List<Transaction> transactions = [];

  bool get isDark => _isDark;
  set isDark(bool dm) {
    _isDark = dm;
    notifyListeners();
  }

  Future<void> loadColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  Future<void> switchColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = !(prefs.getBool('isDark') ?? false);
    prefs.setBool('isDark', isDark);
    notifyListeners();
  }

  Locale get locale => _locale;
  set locale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    locale = Locale(prefs.getString('languageCode') ?? 'en');
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    // checks if the given language code is supported by this
    // application (checks if defined in class lib/l10n/L10n.dart)
    if (!L10n.all.contains(Locale(languageCode))) {
      throw ArgumentError("language code $languageCode is not supported for this application");
    }

    final prefs = await SharedPreferences.getInstance();
    locale = Locale(languageCode);
    prefs.setString('languageCode', languageCode);
    notifyListeners();
  }


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
    final data = await TransactionService.getAllTransactions();
    transactions = data
        .map((tr) => Transaction(
            id: tr['id'],
            name: tr['name'],
            reason: tr['reason'],
            amount: tr['amount'],
            imagePath: tr['imagePath'],
            date: tr['date']))
        .toList();
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
    Map<String, dynamic> tr = {
      "id": id,
      "name": name,
      "reason": reason,
      "amount": amount,
      "imagePath": imagePath,
      "date": date
    };
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
