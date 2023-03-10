import 'dart:io';

import 'package:expenses_app_2/screens/transaction_detail.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpensesMonthTab extends StatefulWidget {
  const ExpensesMonthTab({Key? key}) : super(key: key);

  @override
  State<ExpensesMonthTab> createState() => _ExpensesMonthTabState();
}

class _ExpensesMonthTabState extends State<ExpensesMonthTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TransactionProvider>(context, listen: false)
          .getAllMonthTransactions(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Consumer<TransactionProvider>(
          builder: (context, appProvider, child) {
            final groupedTransactions = appProvider.transactions_per_month;

            return ListView.builder(
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final monthTransactions =
                    groupedTransactions[index].monthTransactions;
                final monthStartDay = groupedTransactions[index].startMonthDay;
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
                            DateFormat.yMMM(appProvider.locale.countryCode)
                                .format(DateTime.parse(monthStartDay)),
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
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: monthTransactions.map(
                            (transaction) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
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
                                    // TODO: show detail of the selected transaction
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionDetail(
                                                    index: index)));
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
