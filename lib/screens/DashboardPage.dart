import 'package:expenses_app_2/components/BottomNavBar.dart';
import 'package:expenses_app_2/models/transaction.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/transaction_amount_grouped_data.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const int _pageIndex = 2;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.dashboard)),
      body: appProvider.transactions.isEmpty
        ? Center(child: Text(AppLocalizations.of(context)!.noDataForDashboard))
        : FutureBuilder(
        future:
            Provider.of<TransactionProvider>(context).getMaxAmountPerMonth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          Transaction lastTransaction = appProvider.transactions.last;
          late Transaction secondLastTransaction;
          double amountDifference = lastTransaction.amount;
          bool badMonth = false;
          bool goodMonth = !badMonth;
          bool onlyOneMonth = false;

          if (appProvider.transactions.length > 1) {
            secondLastTransaction =
                appProvider.transactions[appProvider.transactions.length - 2];

            // more expenses than the second past month: bad month = no money saved
            badMonth = lastTransaction.amount > secondLastTransaction.amount;
            amountDifference = badMonth
                ? amountDifference - secondLastTransaction.amount
                : secondLastTransaction.amount - amountDifference;
            goodMonth = !badMonth;
          } else {
            onlyOneMonth = true;
          }

          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  onlyOneMonth
                      ? Expanded(
                          flex: 1,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                badMonth
                                    ? Image.asset(
                                        'assets/images/icon_money_spent.gif',
                                        width: 100,
                                      )
                                    : Image.asset(
                                        'assets/images/icon_money_saved.gif',
                                        width: 100),
                                Text("Last transactions",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DateFormat.yMMMM(
                                              appProvider.locale.languageCode)
                                          .format(DateTime.parse(
                                              lastTransaction.date))),
                                      Text(_formatToCurrency(
                                          lastTransaction.amount), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600,),),
                                    ]),
                              ]),
                        )
                      : Expanded(
                          flex: 1,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                badMonth && !onlyOneMonth
                                    ? Image.asset(
                                        'assets/images/icon_money_spent.gif',
                                        width: 100,
                                      )
                                    : Image.asset(
                                        'assets/images/icon_money_saved.gif',
                                        width: 100),
                                (() {
                                  if (onlyOneMonth) {
                                    return Text("${AppLocalizations.of(context)!.lastTransaction} ${_formatToCurrency(amountDifference)}",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary));
                                  } else if (badMonth){
                                    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), color: Colors.redAccent.withOpacity(0.2), child: Text("${AppLocalizations.of(context)!.moneySpent} ${_formatToCurrency(amountDifference)}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),),);
                                  } else {
                                    return Container(padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10), color: Colors.greenAccent.withOpacity(0.2), child: Text("${AppLocalizations.of(context)!.moneySaved} ${_formatToCurrency(amountDifference)}", style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)),);
                                  }
                                }()),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DateFormat.yMMMM(
                                              appProvider.locale.languageCode)
                                          .format(DateTime.parse(
                                              lastTransaction.date))),
                                      Icon(!badMonth ? Icons.arrow_upward_outlined : Icons.arrow_downward_outlined, color: badMonth
                                          ? Colors.red.withOpacity(0.8)
                                          : Colors.green),
                                      Text(_formatToCurrency(
                                          lastTransaction.amount),
                                        style: TextStyle(
                                            color: badMonth
                                                ? Colors.red.withOpacity(0.8)
                                                : Colors.green),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DateFormat.yMMMM(
                                              appProvider.locale.languageCode)
                                          .format(DateTime.parse(
                                              secondLastTransaction.date))),
                                      Icon(badMonth ? Icons.arrow_upward_outlined : Icons.arrow_downward_outlined, color: !badMonth
                                        ? Colors.red.withOpacity(0.8)
                                            : Colors.green),
                                      Text(
                                        _formatToCurrency(
                                            secondLastTransaction.amount),
                                        style: TextStyle(
                                            color: !badMonth
                                                ? Colors.red.withOpacity(0.8)
                                                : Colors.green),
                                      ),
                                    ]),
                              ]),
                        ),
                  Expanded(flex: 1, child: _getCircularChart(appProvider)),
                ],
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                title: ChartTitle(
                  text: 'Max expense amount per month',
                ),
                series: _getAreaSeries(appProvider),
                primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat.yM(appProvider.locale.countryCode),
                  intervalType: DateTimeIntervalType.months,
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                ),
                primaryYAxis: NumericAxis(labelFormat: '{value}€'),
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
          ]);
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: _pageIndex),
    );
  }

  Widget _getCircularChart(TransactionProvider provider) {
    return SfCircularChart(
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: [
        PieSeries<MTransactionGroupedAmountData, String>(
          dataSource: provider.maxAmountPerMonth,
          name: AppLocalizations.of(context)!.expenses,
          xValueMapper: (MTransactionGroupedAmountData data, _) =>
              DateFormat.MMMd(provider.locale.languageCode).format(
                  DateTime(DateTime.now().year, int.parse(data.periodDate))),
          yValueMapper: (MTransactionGroupedAmountData data, _) =>
              data.periodAmount,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          enableTooltip: true,
        ),
      ],
    );
  }

  List<LineSeries<MTransactionGroupedAmountData, DateTime>> _getAreaSeries(
      TransactionProvider provider) {
    return <LineSeries<MTransactionGroupedAmountData, DateTime>>[
      LineSeries<MTransactionGroupedAmountData, DateTime>(
        dataSource: provider.maxAmountPerMonth,
        name: AppLocalizations.of(context)!.expenses,
        xValueMapper: (MTransactionGroupedAmountData data, _) =>
            DateTime(DateTime.now().year, int.parse(data.periodDate)),
        yValueMapper: (MTransactionGroupedAmountData data, _) =>
            data.periodAmount,
        dataLabelSettings: const DataLabelSettings(isVisible: true, useSeriesColor: true),
        enableTooltip: true,
        markerSettings: const MarkerSettings(isVisible: true, shape: DataMarkerType.pentagon,)
      ),
    ];
  }

  String _formatToCurrency(double number) {
    return NumberFormat.currency(locale: 'de_DE', symbol: '€')
        .format(number)
        .toString();
  }
}
