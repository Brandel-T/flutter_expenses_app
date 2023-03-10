import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionDetail extends StatelessWidget {
  final int index;

  const TransactionDetail({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    const double paddingX = 10.0;

    return Consumer<TransactionProvider>(
      builder: (context, tProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Transaction detail"),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, paddingX),
            child: Column(
              children: [
                Flexible(
                    flex: 7,
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.file(
                          fit: BoxFit.cover,
                          File(tProvider.transactions[index].imagePath)),
                    )),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: paddingX),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TransactionEntry(
                              context,
                              "${AppLocalizations.of(context)!.at} ",
                              tProvider.transactions[index].date.toString()),
                          TransactionEntry(
                              context,
                              "${AppLocalizations.of(context)!.transaction} ",
                              tProvider.transactions[index].name),
                          TransactionEntry(
                              context,
                              AppLocalizations.of(context)!.reason,
                              tProvider.transactions[index].reason),
                          TransactionEntry(
                              context,
                              "${AppLocalizations.of(context)!.amount} ",
                              "${tProvider.transactions[index].amount} €")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingX),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, paddingX - 5),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.save_outlined),
                        label: Text(AppLocalizations.of(context)!.save),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: paddingX),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(0, paddingX - 5, 0, 0),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_outlined),
                        label: Text(AppLocalizations.of(context)!.delete),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              return Theme.of(context).colorScheme.error;
                            },
                          ),
                          foregroundColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) =>
                                  Theme.of(context).colorScheme.onError),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget TransactionEntry(BuildContext context, String label, String entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        Text(label, style: TextStyle(color: Theme.of(context).hintColor)),
        Text(entry),
      ],
    );
  }
}
