import 'package:expenses_app_2/components/ExpensesList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';

// custom theme
import '../../models/period_type.dart';

class ExpensesWeekTab extends StatefulWidget {
  const ExpensesWeekTab({Key? key}) : super(key: key);

  @override
  State<ExpensesWeekTab> createState() => _ExpensesWeekTabState();
}

class _ExpensesWeekTabState extends State<ExpensesWeekTab> {
  @override
  Widget build(BuildContext context) {
    return ExpensesList(
      loadData: Provider.of<TransactionProvider>(context, listen: false)
          .getAllWeekTransactions(),
      periodType: PeriodType.week,
    );
  }
}
