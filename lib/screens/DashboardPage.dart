import 'package:expenses_app_2/components/BottomNavBar.dart';
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.dashboard)),
      body: FutureBuilder(
        future: Provider.of<TransactionProvider>(context).getMaxAmountPerMonth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return SfCartesianChart(
            title: ChartTitle(text: 'Max expense amount per month'),
            series: _getAreaSeries(appProvider),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.yM(appProvider.locale.countryCode),
              intervalType: DateTimeIntervalType.months,
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
            ),
            primaryYAxis: NumericAxis(labelFormat: '{value}€'),
            tooltipBehavior: TooltipBehavior(enable: true),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: _pageIndex),
    );
  }

  List<AreaSeries<MTransactionGroupedAmountData, DateTime>> _getAreaSeries(TransactionProvider provider) {
    return <AreaSeries<MTransactionGroupedAmountData, DateTime>> [
      AreaSeries<MTransactionGroupedAmountData, DateTime>(
          dataSource: provider.maxAmountPerMonth,
          name: AppLocalizations.of(context)!.this_month,
          xValueMapper: (MTransactionGroupedAmountData data, _) => DateTime(DateTime.now().year, int.parse(data.periodDate)),
          yValueMapper: (MTransactionGroupedAmountData data, _) => data.periodAmount
      ),
    ];
  }
}
