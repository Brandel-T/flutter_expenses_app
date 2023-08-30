import 'package:expenses_app_2/models/period_type.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/transaction.dart';
import '../screens/HomePage.dart';
import 'TransactionItem.dart';

class ExpensesList extends StatelessWidget {
  final Future<void> future;
  final PeriodType periodType;

  const ExpensesList({
    super.key,
    required this.future,
    required this.periodType,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Consumer<TransactionProvider>(
          builder: (context, appProvider, child) {
            var groupedTransactions = [];
            switch (periodType) {
              case PeriodType.month:
                groupedTransactions = appProvider.transactions_per_month;
                break;
              case PeriodType.year:
                groupedTransactions = appProvider.transactions_per_year;
                break;
              default:
                groupedTransactions = appProvider.transactions_per_week;
            }

            return groupedTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.no_entry),
                        TextButton(
                          onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ))
                          },
                          child: Text(AppLocalizations.of(context)!.home),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: groupedTransactions.length,
                    itemBuilder: (context, index) {
                      var periodTransactions = [];
                      String periodStart = "0";
                      switch (periodType) {
                        case PeriodType.month:
                          periodTransactions =
                              groupedTransactions[index].monthTransactions;
                          periodStart =
                              groupedTransactions[index].startMonthDay;
                          break;
                        case PeriodType.year:
                          periodTransactions =
                              groupedTransactions[index].yearTransactions;
                          periodStart = groupedTransactions[index].year;
                          break;
                        default:
                          periodTransactions =
                              groupedTransactions[index].weekTransactions;
                          periodStart = groupedTransactions[index].startWeekDay;
                      }
                      final totalAmount =
                          NumberFormat(".00#", appProvider.locale.countryCode)
                              .format(groupedTransactions[index].totalAmount);
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (periodType == PeriodType.week) ...[
                                  Text(
                                    DateFormat.yMMMEd(
                                            appProvider.locale.countryCode)
                                        .format(DateTime.parse(periodStart)),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  )
                                ] else if (periodType == PeriodType.month) ...[
                                  Text(
                                    DateFormat.yMMMM(
                                            appProvider.locale.countryCode)
                                        .format(DateTime.parse(periodStart)),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ] else ...[
                                  Text(
                                    DateFormat.y(appProvider.locale.countryCode)
                                        .format(DateTime.parse(periodStart)),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                                Text(
                                  "$totalAmount €",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: periodTransactions.map((transaction) {
                              return TransactionItem(
                                context: context,
                                provider: appProvider,
                                transaction: Transaction(
                                  id: transaction['id'],
                                  name: transaction['name'],
                                  reason: transaction['reason'],
                                  amount: transaction['amount'],
                                  imagePath: transaction['imagePath'],
                                  date: transaction['date'],
                                ),
                              );
                            }).toList(),
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
