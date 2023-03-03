import 'dart:io';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                          File(tProvider.transactions[index].imagePath)
                      ),
                    )
                ),
                Expanded(
                    flex: 4,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: paddingX),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TransactionEntry(context, "At ", tProvider.transactions[index].date.toString()),
                              TransactionEntry(context, "Name ", tProvider.transactions[index].name),
                              TransactionEntry(context, "Reason", tProvider.transactions[index].reason),
                              TransactionEntry(context, "Amount ", "${tProvider.transactions[index].amount} €")
                            ],
                          ),
                        )
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: paddingX),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, paddingX-5),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.save_outlined),
                          label: const Text("save"),
                        ),
                      ),
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: paddingX),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(0, paddingX-5, 0, 0),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.delete_outlined),
                          label: const Text("Delete"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                return Theme.of(context).colorScheme.error;
                              },),
                            foregroundColor: MaterialStateColor.resolveWith(
                                    (Set<MaterialState> states) => Theme.of(context).colorScheme.onError
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
          )
        );
      },
    );
  }

  Widget TransactionEntry(BuildContext context, String label, String entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0,),
        Text(label, style: TextStyle(color: Theme.of(context).hintColor),),
        Text(entry),
      ],
    );
  }
}
