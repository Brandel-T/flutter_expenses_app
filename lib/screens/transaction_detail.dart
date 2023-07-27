import 'dart:io';
import 'package:expenses_app_2/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  late TransactionProvider appProvider;
  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String id = "";
  String name = "";
  String reason = "";
  double amount = 0;
  String date = "";
  String imagePath = "";

  bool saveButtonDisabled = true;
  bool cancelButtonDisabled = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final Transaction routeArgs = ModalRoute.of(context)!.settings.arguments as Transaction;
      id = routeArgs.id;
      name = routeArgs.name;
      reason = routeArgs.reason;
      date = routeArgs.date;
      amount = routeArgs.amount;
      imagePath = routeArgs.imagePath;

      _transactionController.text = name;
      _amountController.text = "$amount";
      _reasonController.text = reason;

      Transaction? tr = await Provider.of<TransactionProvider>(context, listen: false).getTransactionById(id);
      imagePath = tr!.imagePath;
      date = tr.date;
    });
  }

  @override
  void dispose() {
    _transactionController.dispose();
    _reasonController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    final image = await ImagePicker.platform.pickImage(source: ImageSource.camera, maxWidth: 600);
    setState(() {
      imagePath = image!.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double paddingX = 10.0;
    appProvider = Provider.of<TransactionProvider>(context, listen: false);
    final Transaction args = ModalRoute.of(context)!.settings.arguments as Transaction;
    date = args.date;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, paddingX),
        child: Column(
          children: [
            Flexible(
              flex: 7,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: imagePath.isEmpty
                      ? FutureBuilder(
                          initialData: imagePath,
                          future: Provider.of<TransactionProvider>(context).getTransactionById(id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting || appProvider.transaction!.imagePath.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.no_photography_outlined, size: 100, weight: 0.5),
                                  Text(AppLocalizations.of(context)!.no_picture_taken),
                                ],
                              );
                            }
                            return Image.file(
                              fit: BoxFit.cover,
                              File(appProvider.transaction!.imagePath),
                            );
                          },
                        )
                      : Image.file(
                          fit: BoxFit.cover,
                          File(imagePath),
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
                      child: Text("${
                        AppLocalizations.of(context)!.at} ${DateFormat.yMMMMEEEEd(appProvider.locale.countryCode).format(DateTime.parse(date))
                        }",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w400,
                          fontSize: 13
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: paddingX,
                ),
                
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.only(top: 0),
                      children: [
                        TransactionEntry(
                          context,
                          _transactionController,
                          AppLocalizations.of(context)!.transaction,
                          name,
                        ),
                        const Divider(height: 6, color: Colors.transparent),
                        TransactionEntry(
                          context,
                          _reasonController,
                          AppLocalizations.of(context)!.reason,
                          reason,
                        ),
                        const Divider(height: 6, color: Colors.transparent),
                        TransactionEntry(
                          context,
                          _amountController,
                          AppLocalizations.of(context)!.amount,
                          "$amount €",
                          isNumber: true,
                        ),
                      ],
                    ),
                  ),
                
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _takePicture();
        },
        backgroundColor: Theme.of(context).indicatorColor,
        child: Icon(Icons.camera_alt_rounded, color: Theme.of(context).colorScheme.surface,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 8.0,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              FilledButton.tonal(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    appProvider.addTransaction(
                      id,
                      _transactionController.text.trim(),
                      _reasonController.text.trim(),
                      double.parse(_amountController.text.trim()),
                      imagePath,
                      date
                    );
                    Navigator.of(context).pop();
                    Provider.of<TransactionProvider>(context, listen: false).getAllTransactions();
                    Provider.of<TransactionProvider>(context, listen: false).getAllWeekTransactions();
                    Provider.of<TransactionProvider>(context, listen: false).getAllMonthTransactions();
                    Provider.of<TransactionProvider>(context, listen: false).getAllYearTransactions();
                  }
                },
                
                style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.inversePrimary), ),
                // icon: Icon(Icons.save_outlined, color: Theme.of(context).colorScheme.primary),
                child: Row(
                  children: [
                   Container(margin: const EdgeInsets.only(right: 4), child: const Icon(Icons.save_rounded),),
                    Text(AppLocalizations.of(context)!.save,)
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  appProvider.deleteTransaction(id);
                  Navigator.of(context).pop();
                  final snackBar = SnackBar(
                    content: Text("${ AppLocalizations.of(context)!.transaction_deleted }!"),
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
                  foregroundColor: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) =>
                      Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TransactionEntry(BuildContext context, TextEditingController controller, String label, String entry, { bool? isNumber = false }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: label
      ),
      keyboardType: isNumber! ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.required_form_field_message;
        }
        return null;
      },
    );
  }
}
