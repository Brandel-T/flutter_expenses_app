import 'dart:io';
import 'package:expenses_app_2/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app_2/screens/transaction_detail.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';

class ExpensesWeekTab extends StatefulWidget {
  const ExpensesWeekTab({Key? key}) : super(key: key);

  @override
  State<ExpensesWeekTab> createState() => _ExpensesWeekTabState();
}

class _ExpensesWeekTabState extends State<ExpensesWeekTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TransactionProvider>(context, listen: false)
          .getAllWeekTransactions(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Consumer<TransactionProvider>(
          builder: (context, appProvider, child) {
            final groupedTransactions = appProvider.transactions_per_week;

            return groupedTransactions.isEmpty
                ? const Center(child: Text('No entries'),)
                : ListView.builder(
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final weekTransactions =
                    groupedTransactions[index].weekTransactions;
                final weekStartDay = groupedTransactions[index].startWeekDay;

                // format the total amount to two decimal places
                final totalAmount =
                NumberFormat(".0#", appProvider.locale.countryCode)
                    .format(groupedTransactions[index].totalAmount);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat.yMMMd(appProvider.locale.countryCode)
                                .format(DateTime.parse(weekStartDay)),
                          ),
                          Text(
                            "$totalAmount €",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Column(
                          children: weekTransactions.map( (transaction) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                      child: Image.file(
                                          File(transaction["imagePath"])),
                                    ),
                                  ),
                                  title: Text(
                                    transaction["name"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(transaction["reason"]),
                                      Text(
                                        DateFormat.yMEd(
                                            appProvider.locale.countryCode)
                                            .format(DateTime.parse(
                                            transaction["date"])),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    "${transaction["amount"]} €",
                                    style:
                                    Theme.of(context).textTheme.titleMedium,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      TransactionDetail.routeName,
                                      arguments: Transaction(
                                        id: transaction['id'],
                                        name: transaction['name'],
                                        reason: transaction['reason'],
                                        amount: transaction['amount'],
                                        imagePath: transaction['imagePath'],
                                        date: transaction['date'],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
