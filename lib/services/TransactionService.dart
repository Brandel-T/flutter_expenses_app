import 'dart:async';
import 'package:expenses_app_2/models/transaction.dart' as tr;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/widgets.dart';

class TransactionService {
  static const TABLE_NAME = 'user_transaction';

  static Future<sql.Database> openDB() async {
    final dbPath = await sql.getDatabasesPath();

    return sql.openDatabase(version: 1, path.join(dbPath, 'transaction_db.db'),
        onCreate: (sql.Database db, int version) async {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS $TABLE_NAME (
            id TEXT PRIMARY KEY,
            name TEXT not null,
            reason TEXT not null,
            amount REAL not null,
            imagePath TEXT not null,
            date TEXT not null
          )''');
    });
  }

  /// insert a new transaction into the db
  static Future<void> insertTransaction(tr.Transaction transaction) async {
    try {
      final db = await TransactionService.openDB();

      try {
        db.insert(TABLE_NAME, transaction.toMap(),
            conflictAlgorithm: sql.ConflictAlgorithm.replace);
      } catch (ee) {
        debugPrint('Can not intert $transaction into the db.');
        debugPrint(ee.toString());
      }
    } catch (e) {
      debugPrint('can not open the db: $e');
    }
  }

  /// get all entries from the db
  /// returns a list of transactions
  static Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final db = await TransactionService.openDB();
    return db.rawQuery('''
       SELECT *, strftime('%W', date(date)) as calendar_week, strftime('%m', date(date)) as calendar_month, strftime('%Y', date(date)) as calendar_year
       FROM $TABLE_NAME
       ORDER BY date(date) ASC
     ''');
  }

  /// delete a transaction from the db
  /// returns the number of rows affected
  static Future<int> deleteTransaction(String id) async {
    final db = await TransactionService.openDB();
    return db.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  /// update a transaction in the db
  /// returns the number of rows affected
  static Future<int> updateTransaction(tr.Transaction data) async {
    final db = await TransactionService.openDB();
    return db.update(
      TABLE_NAME,
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  /// get the last 10 most expensive transactions of the current month
  static Future<List<Map<String, dynamic>>> getMostExpensiveTransactionOfMonth() async {
    final db = await TransactionService.openDB();
    const sql = '''SELECT DISTINCT * FROM $TABLE_NAME
                   WHERE STRFTIME('%m', DATE(date)) = STRFTIME('%m', DATE('now'))
                   ORDER BY amount DESC
                   LIMIT 10''';
    return db.rawQuery(sql);
  }

  /// get total amount of the month
  static Future getTotalAmountOfMonth() async {
    final db = await TransactionService.openDB();
    return db.rawQuery('''
      SELECT SUM(amount) as total_month_amount
      FROM $TABLE_NAME
      WHERE STRFTIME('%m', DATE(date)) = STRFTIME('%m', DATE('now'))
    ''');
  }

  /// get the last transaction
  static Future getLastTransaction() async {
    final db = await TransactionService.openDB();
    // String sql = 'SELECT * FROM $TABLE_NAME ORDER BY DATE(date) DESC LIMIT 1';
    return db.query(TABLE_NAME, orderBy: 'DATE(date) DESC', limit: 1);
  }
}
