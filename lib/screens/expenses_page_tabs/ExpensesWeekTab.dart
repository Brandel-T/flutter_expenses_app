import 'package:expenses_app_2/models/transaction.dart';
import 'package:expenses_app_2/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// custom theme
import '../../themes/main.dart' as main;
import '../transaction_detail.dart';

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
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.no_entry),
                      TextButton(
                        onPressed: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const HomePage(),)
                          )
                        },
                        child: Text(AppLocalizations.of(context)!.home),
                      ),
                    ],
                  ),
                )
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
                                DateFormat.yMMMEd(appProvider.locale.countryCode)
                                    .format(DateTime.parse(weekStartDay)),
                              ),
                              Text(
                                "$totalAmount €",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.onBackground,
                                    fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Column(
                            children: weekTransactions.map( (transaction) {
                              return _transactionItem(
                                  context,
                                  provider: appProvider,
                                  transaction: Transaction(
                                      id: transaction['id'],
                                      name: transaction['name'],
                                      reason: transaction['reason'],
                                      amount: transaction['amount'],
                                      imagePath: transaction['imagePath'],
                                      date: transaction['date']
                                  )
                              );
                            }).toList(),
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

  Widget _transactionItem(
    BuildContext context, {
    required TransactionProvider provider,
    required Transaction transaction,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              TransactionDetail.routeName,
              arguments: Transaction(
                reason: transaction.reason,
                amount: transaction.amount,
                name: transaction.name,
                date: transaction.date,
                imagePath: transaction.imagePath,
                id: transaction.id
              ),
            );
          },
          child: ListTile(
            leading: Text(
              (DateTime.parse(transaction.date).compareTo(DateTime.now()) == 0) ? "Today" : DateFormat.MMMd(provider.locale.countryCode).format(DateTime.parse(transaction.date)),
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, color: Theme.of(context).hintColor)
            ),
            title: Text(transaction.name, style: const TextStyle(fontWeight: FontWeight.w400),), 
            subtitle: Text(transaction.reason, style: TextStyle(color: Theme.of(context).hintColor)),
            trailing: Text(
              NumberFormat.currency(locale: 'de_DE', symbol: '€').format(transaction.amount),
              style: TextStyle(color: Colors.green[400], fontWeight: FontWeight.w600, fontSize: 14),
            ),
            tileColor: Theme.of(context).colorScheme.background,
          ),
        ),
        Divider(color: Theme.of(context).dividerColor, indent: 50, height: 1,)
      ],
    );
  }
}
