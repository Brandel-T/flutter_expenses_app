import 'dart:io';
import 'package:expenses_app_2/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionDetail extends StatefulWidget {
  static const routeName = 'detail';
  final int? index;

  const TransactionDetail({super.key, this.index});

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _transactionController.text = "";
    _amountController.text = "";
    _reasonController.text = "";
  }

  @override
  void dispose() {
    _transactionController.dispose();
    _reasonController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<TransactionProvider>(context, listen: false);
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Transaction;
    String id = routeArgs.id;
    String name = routeArgs.name;
    String reason = routeArgs.reason;
    double amount = routeArgs.amount;
    String imagePath = routeArgs.imagePath;
    String date = routeArgs.date;

    _transactionController.text = name;
    _reasonController.text = reason;
    _amountController.text = "$amount";

    const double paddingX = 10.0;


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Transaction detail")
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, paddingX),
        child: Column(
          children: [
            Flexible(
              flex: 7,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SizedBox(
                      width: double.infinity,
                      child: imagePath == "" ? const Text('No taken picture') : Image.file(
                        fit: BoxFit.cover,
                        File(imagePath),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.8)
                      ),
                      child: Text(style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 24), "${AppLocalizations.of(context)!.at} ${DateFormat.yMMMEd(appProvider.locale.countryCode).format(DateTime.parse(date))}"),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: paddingX),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Expanded(
                      //                         flex: 1,
                      //                         child: TransactionEntry(
                      //                           context,
                      //                           "${AppLocalizations.of(context)!.at} ",
                      //                           date.toString()),
                      //                       ),

                      Expanded(
                        flex: 1,
                        child: TransactionEntry(
                          context,
                          _transactionController,
                          "${AppLocalizations.of(context)!.transaction} ",
                          name),
                      ),
                      Expanded(
                        flex: 1,
                        child: TransactionEntry(
                          context,
                          _reasonController,
                          AppLocalizations.of(context)!.reason,
                          reason),
                      ),
                      Expanded(
                        flex: 1,
                        child: TransactionEntry(
                          context,
                          _amountController,
                          "${AppLocalizations.of(context)!.amount} ",
                          "$amount €"),
                      )
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
                    onPressed: () {
                      appProvider.addTransaction(
                          id,
                          _transactionController.text,
                          _reasonController.text,
                          double.parse(_amountController.text),
                          imagePath,
                          date
                      );
                      Navigator.of(context).pop();
                    },
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
                    onPressed: () {
                      appProvider.deleteTransaction(id);
                      Navigator.of(context).pop();
                      final snackBar = SnackBar(
                        content: const Text('Transaction deleted!'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            // on undo
                            appProvider.addTransaction(id, name, reason, amount, imagePath, date);
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
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
  }

  Widget TransactionEntry(BuildContext context, TextEditingController controller, String label, String entry) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: label
      ),
    );
  }
}
