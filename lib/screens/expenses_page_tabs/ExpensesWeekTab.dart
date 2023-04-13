import 'package:expenses_app_2/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';

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
                    ),Padding(
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
                        },
                        ).toList(),
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          TransactionDetail.routeName,
          arguments: Transaction(
            id: transaction.id,
            name: transaction.name,
            reason: transaction.reason,
            amount: transaction.amount,
            imagePath: transaction.imagePath,
            date: transaction.date,
          ),
        );
      },
      child: Container(
        height: main.transactionHeight,
        width: double.infinity,
        margin: const EdgeInsets.only(left: main.horizontalOffset/2, right: main.horizontalOffset/2, bottom: main.verticalOffset),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(main.transactionRadius),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
          boxShadow: const [
            main.boxShadow
          ],
        ),
        constraints: const BoxConstraints(minHeight: main.transactionHeight),
        clipBehavior: Clip.none,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            /*
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: SizedBox(
                child: Image.file(
                    File(transaction.imagePath)),
              ),
            ),
             */
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMEd(
                        provider.locale.countryCode)
                        .format(DateTime.parse(
                        transaction.date)),
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary,
                        fontSize: 11),
                  ),
                  Expanded(
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: Text(transaction.name, style: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  Expanded(child: Text(transaction.reason)),
                  // Text(reason!, style: Theme.of(context).textTheme.bodyMedium,),
                ],
              ),
            ),
            Text(NumberFormat.currency(locale: provider.locale.countryCode, symbol: "€").format(transaction.amount), style: const TextStyle(color: Colors.green, fontSize: 14.0, fontWeight: FontWeight.w400),)
          ],
        ),
      ),
    );
  }
}
