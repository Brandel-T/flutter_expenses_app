import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final DateTime? selectedDay;

  const TransactionForm({
    super.key,
    required this.selectedDay,
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
    final image = await ImagePicker.platform.pickImage(
        source: ImageSource.camera,
        maxWidth: 600
    );
    setState(() {
      _invoiceImagePath = image!.path;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  "Expenses of ${widget.selectedDay}",
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              InputField(
                _transactionController,
                const Icon(Icons.shopping_cart),
                "Transaction",
                TextInputType.text,
              ),
              InputField(
                  _reasonController,
                  const Icon(Icons.question_mark_sharp),
                  "Reason",
                  TextInputType.text
              ),
              InputField(
                _amountController,
                const Icon(Icons.euro),
                "Amount",
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
                              color: Colors.transparent
                          ),
                          child: _invoiceImagePath != ""
                              ? Image.file(File(_invoiceImagePath), fit: BoxFit.cover ,)
                              : const Center(child: Text('Tap to add a picture of the invoice', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, ),),),
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
                                      const SnackBar(
                                          content: Text('Processing Data ...')
                                      ),
                                    );
                                    // TODO: Save the new transaction
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
                                },
                                child: const Text("Save"),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget InputField(
  TextEditingController controller,
  Widget prefixIcon,
  String hintText,
  TextInputType inputType,
) {
  return Container(
    margin: const EdgeInsets.only(top: 10.0),
    //decoration: BoxDecoration(
      //color: Colors.grey[200],
      //borderRadius: BorderRadius.circular(10.0),
    //),
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
          return "This field is required";
        }
        return null;
      },
    ),
  );
}
