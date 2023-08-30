import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/ExpensesList.dart';
import '../../models/period_type.dart';

class ExpensesYearTab extends StatefulWidget {
  const ExpensesYearTab({Key? key}) : super(key: key);

  @override
  State<ExpensesYearTab> createState() => _ExpensesYearTabState();
}

class _ExpensesYearTabState extends State<ExpensesYearTab> {
  @override
  Widget build(BuildContext context) {
    return ExpensesList(
      loadData: Provider.of<TransactionProvider>(context, listen: false)
          .getAllYearTransactions(),
      periodType: PeriodType.year,
    );
  }
}
