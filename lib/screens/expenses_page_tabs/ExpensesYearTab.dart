import 'dart:io';

import 'package:expenses_app_2/screens/transaction_detail.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpensesYearTab extends StatefulWidget {
  const ExpensesYearTab({Key? key}) : super(key: key);

  @override
  State<ExpensesYearTab> createState() => _ExpensesYearTabState();
}

class _ExpensesYearTabState extends State<ExpensesYearTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TransactionProvider>(context, listen: false)
          .getAllYearTransactions(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Consumer<TransactionProvider>(
          builder: (context, appProvider, child) {
            final groupedTransactions = appProvider.transactions_per_year;

            return ListView.builder(
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final yearTransactions =
                    groupedTransactions[index].yearTransactions;
                final year = groupedTransactions[index].year;
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
                            DateTime.parse(year).year == DateTime.now().year
                                ? AppLocalizations.of(context)!.this_year
                                : DateFormat.y(appProvider.locale.countryCode)
                                    .format(DateTime.parse(year)),
                          ),
                          Text(
                            "$totalAmount €",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
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
                          children: yearTransactions.map(
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
