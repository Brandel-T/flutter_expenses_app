import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:expenses_app_2/screens/transaction_detail.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';

class ExpenseTab extends StatefulWidget {
  final Function requestData;

  const ExpenseTab({super.key, required this.requestData});

  @override
  State<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends State<ExpenseTab> {
  Function _requestData => widget.requestData;
  
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

            return ListView.builder(
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final weekTransactions =
                    groupedTransactions[index].weekTransactions;
                final weekStartDay = groupedTransactions[index].startWeekDay;
                final totalAmount = groupedTransactions[index].totalAmount;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat.yMd(appProvider.locale.countryCode)
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
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: weekTransactions.map(
                            (transaction) {
                              return ListTile(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(transaction["reason"]),
                                    Text(
                                      DateFormat.yMMMMd(
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          TransactionDetail(index: index)));
                                },
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ],
                );
              },
              // separatorBuilder: (BuildContext context, int index) =>
              //     const Divider(),
            );
          },
        );
      },
    );
  }
}