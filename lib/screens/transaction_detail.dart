import 'dart:io';
import 'package:expenses_app_2/components/TransactionDetailPanel.dart';
import 'package:expenses_app_2/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:photo_view/photo_view.dart';

class TransactionDetail extends StatefulWidget {
  static const routeName = 'detail';
  final int? index;

  const TransactionDetail({super.key, this.index});

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  late PanelController _panelController;
  double _datePositionTop = 10.0;

  @override
  void initState() {
    _panelController = PanelController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<TransactionProvider>(context, listen: false);
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Transaction;
    String imagePath = routeArgs.imagePath;
    String date = routeArgs.date;

    double panelMinHeight = MediaQuery.of(context).size.height * 0.11;
    double panelMaxHeight = MediaQuery.of(context).size.height * 0.55;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Transaction detail")),
      body: SlidingUpPanel(
        minHeight: panelMinHeight,
        maxHeight: panelMaxHeight,
        parallaxEnabled: false,
        parallaxOffset: 0.5,
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        controller: _panelController,
        body: Stack(
          children: [
            Positioned.fill(
              child: SizedBox(
                width: double.infinity,
                child: imagePath == ""
                  ? const Text('No taken picture')
                  : PhotoView.customChild(child: Image.file(fit: BoxFit.cover, File(imagePath)))
              ),
            ),
            Positioned(
              left: 10,
              top: _datePositionTop,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(20))
                ),
                child: Text(style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontWeight: FontWeight.w100, fontSize: 18), "${AppLocalizations.of(context)!.at} ${DateFormat.yMMMEd(appProvider.locale.countryCode).format(DateTime.parse(date))}"),
              ),
            ),
          ],
        ),
        panelBuilder: (controller) => TransactionDetailPanel(
          scrollController: controller,
          panelController: _panelController,
        ),
      ),
    );
  }
}
