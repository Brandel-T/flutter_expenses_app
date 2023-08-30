import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/ExpensesList.dart';
import '../../models/period_type.dart';

class ExpensesMonthTab extends StatefulWidget {
  const ExpensesMonthTab({Key? key}) : super(key: key);

  @override
  State<ExpensesMonthTab> createState() => _ExpensesMonthTabState();
}

class _ExpensesMonthTabState extends State<ExpensesMonthTab> {
  @override
  Widget build(BuildContext context) {
    return ExpensesList(
      loadData: Provider.of<TransactionProvider>(context, listen: false)
          .getAllMonthTransactions(),
      periodType: PeriodType.month,
    );
  }
}
