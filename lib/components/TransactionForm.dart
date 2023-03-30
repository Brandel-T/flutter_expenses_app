import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionForm extends StatefulWidget {
  final DateTime? selectedDay;
  final Function closeModal;

  const TransactionForm({
    super.key,
    required this.selectedDay,
    required this.closeModal,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  /// key for form validation
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _transactionController.dispose();
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  /// Foto der Rechnung
  String _invoiceImagePath = "";

  void _takePicture() async {
    final image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, maxWidth: 600);
    setState(() {
      _invoiceImagePath = image!.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    return Form(
      key: _formKey,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "${AppLocalizations.of(context)!.expensesFrom} ${DateFormat.yMMMMd(appProvider.locale.countryCode).format(widget.selectedDay ?? DateTime.now())}",
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              _inputField(
                context,
                _transactionController,
                const Icon(Icons.shopping_cart),
                AppLocalizations.of(context)!.transaction,
                TextInputType.text,
              ),
              _inputField(
                  context,
                  _reasonController,
                  const Icon(Icons.question_mark_sharp),
                  AppLocalizations.of(context)!.reason,
                  TextInputType.text),
              _inputField(
                context,
                _amountController,
                const Icon(Icons.euro),
                AppLocalizations.of(context)!.amount,
                TextInputType.number,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _takePicture(),
                      child: Container(
                        height: double.infinity,
                        width: 250,
                        margin: const EdgeInsets.fromLTRB(0, 10, 4, 0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.transparent,
                        ),
                        child: _invoiceImagePath != ""
                            ? Image.file(
                                File(_invoiceImagePath),
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .take_picture_filed_message,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Consumer<TransactionProvider>(
                      builder: (context, transactionProvider, child) {
                        return Expanded(
                          child: Container(
                            height: double.infinity,
                            margin: const EdgeInsets.only(top: 10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(AppLocalizations.of(context)!.loading),
                                    ),
                                  );

                                  Uuid id = const Uuid();
                                  transactionProvider.addTransaction(
                                    id.v1(),
                                    _transactionController.text,
                                    _reasonController.text,
                                    double.parse(_amountController.text),
                                    _invoiceImagePath,
                                    widget.selectedDay!.toIso8601String(),
                                  );
                                }

                                widget.closeModal();
                              },
                              child: Text(AppLocalizations.of(context)!.save),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _inputField(
  BuildContext context,
  TextEditingController controller,
  Widget prefixIcon,
  String hintText,
  TextInputType inputType,
) {
  return Container(
    margin: const EdgeInsets.only(top: 10.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.required_form_field_message;
        }
        return null;
      },
    ),
  );
}
