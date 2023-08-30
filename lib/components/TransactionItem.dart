import 'package:expenses_app_2/models/transaction.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/transaction_detail.dart';
import 'DateIcon.dart';

class TransactionItem extends StatelessWidget {
  final BuildContext context;
  final TransactionProvider provider;
  final Transaction transaction;

  const TransactionItem({
    super.key,
    required this.context,
    required this.provider,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            id: transaction.id,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 6),
        child: ListTile(
          leading: DateIcon(
            date: DateFormat.d(provider.locale.countryCode)
                .format(DateTime.parse(transaction.date)),
          ),
          title: Text(
            transaction.name,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          subtitle: Text(transaction.reason,
              style: TextStyle(color: Theme.of(context).hintColor)),
          trailing: Text(
            NumberFormat.currency(locale: 'de_DE', symbol: '€')
                .format(transaction.amount),
            style: TextStyle(
              color: Colors.green[300],
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          tileColor: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
