import 'dart:io';

import 'package:expenses_app_2/screens/transaction_detail.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesWeekTab extends StatefulWidget {
  const ExpensesWeekTab({Key? key}) : super(key: key);

  @override
  State<ExpensesWeekTab> createState() => _ExpensesWeekTabState();
}

class _ExpensesWeekTabState extends State<ExpensesWeekTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TransactionProvider>(context, listen: false).getAllTransactions(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Consumer<TransactionProvider>(
          builder: (context, transactionProvider, child) {
            return ListView.separated(
              itemCount: transactionProvider.transactions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: SizedBox(
                      child: Image.file(File(transactionProvider.transactions[index].imagePath)),
                    ),
                  ),
                  title: Text(transactionProvider.transactions[index].name, style: const TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transactionProvider.transactions[index].reason),
                      Text(transactionProvider.transactions[index].date.toString(),
                        style: const TextStyle(color: Colors.black26, fontSize: 11),
                      ),
                    ],
                  ),
                  trailing: Text("${transactionProvider.transactions[index].amount} €"),
                  onTap: () {
                    // TODO: show detail of the selected transaction
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TransactionDetail(index: index))
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            );
          },
        );
      },
    );
  }
}
