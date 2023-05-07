import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../models/transaction.dart';
import '../store/transaction_provider.dart';
import '../utils/helpers.dart';

class TransactionDetailPanel extends StatefulWidget {
  final ScrollController scrollController;
  final PanelController panelController;

  const TransactionDetailPanel({
    Key? key,
    required this.scrollController,
    required this.panelController,
  }) : super(key: key);

  @override
  State<TransactionDetailPanel> createState() => _TransactionDetailPanelState();
}

class _TransactionDetailPanelState extends State<TransactionDetailPanel> {
  /// key for panel form validation
  final _panelFormKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();
  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    Future.delayed(Duration.zero, () {
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Transaction;
      _selectedDate = DateTime.parse(routeArgs.date);
      _transactionController.text = routeArgs.name;
      _amountController.text = '${routeArgs.amount}';
      _reasonController.text = routeArgs.reason;
    });
  }

  @override
  void dispose() {
    _transactionController.dispose();
    _reasonController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _togglePanel() {
    if (widget.panelController.isPanelOpen) {
      widget.panelController.close();
    } else {
      widget.panelController.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<TransactionProvider>(context, listen: false);

    final routeArgs = ModalRoute.of(context)!.settings.arguments as Transaction;
    String id = routeArgs.id;
    String imagePath = routeArgs.imagePath;

    const double paddingX = 10.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, paddingX),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Form(
        key: _panelFormKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: _togglePanel,
              child: Container(
                height: 6,
                width: 44,
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: appProvider.isDark
                        ? Theme.of(context).colorScheme.onTertiary
                        : Colors.grey
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: paddingX),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_month_outlined),
                        onPressed: _showDatePicker,
                        label: const Text('Date Picker'),
                      ),
                      _rowGap(gap: 4),
                      _transactionEntry (
                        context,
                        controller: _transactionController,
                        placeholder: AppLocalizations.of(context)!.transaction,
                        prefixIcon: const Icon(Icons.shopping_cart),
                        keyboardType: TextInputType.text,
                      ),
                      _rowGap(gap: 8),
                      _transactionEntry(
                        context,
                        maxLines: 3,
                        controller: _reasonController,
                        placeholder: AppLocalizations.of(context)!.reason,
                        prefixIcon: const Icon(Icons.question_mark_outlined),
                        keyboardType: TextInputType.text,
                      ),
                      _rowGap(gap: 8),
                      _transactionEntry(
                        context,
                        controller: _amountController,
                        placeholder: AppLocalizations.of(context)!.amount,
                        prefixIcon: const Icon(Icons.euro_outlined),
                        keyboardType: TextInputType.number,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingX),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (_panelFormKey.currentState!.validate()) {
                            appProvider.addTransaction(
                              id,
                              _transactionController.text,
                              _reasonController.text,
                              double.parse(_amountController.text),
                              imagePath,
                              _selectedDate.toIso8601String(),
                            );
                            Navigator.of(context).pop();
                          }
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
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          appProvider.deleteTransaction(id);
                          Navigator.of(context).pop();
                          final snackBar = SnackBar(
                            content: const Text('Transaction deleted!'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                // on undo
                                appProvider.addTransaction(
                                  id,
                                  _transactionController.text,
                                  _reasonController.text,
                                  double.parse(_amountController.text),
                                  imagePath,
                                  _selectedDate.toIso8601String(),
                                );
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
            )
          ],
        ),
      ),
    );
  }

  void _showDatePicker() {
    DateTime now = DateTime.now();

    showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    ).then((value) {
      setState(() {
        _selectedDate = value ?? DateTime.now();
      });
    });
  }

  Widget _rowGap({double? gap = 2}) => SizedBox(height: gap);

  Widget _transactionEntry(
      BuildContext context, {
      required TextEditingController controller,
      required TextInputType keyboardType,
      required String placeholder,
      int? maxLines = 1,
      required Icon prefixIcon
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
          prefixIcon: prefixIcon,
          border: InputBorder.none,
          hintText: placeholder
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.required_form_field_message;
        }
        return null;
      },
    );
  }
}
