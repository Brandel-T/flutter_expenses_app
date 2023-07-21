import 'package:expenses_app_2/components/BottomNavBar.dart';
import 'package:expenses_app_2/models/transaction.dart';
import 'package:expenses_app_2/models/transaction_per_month.dart';
import 'package:expenses_app_2/screens/transaction_detail.dart';
import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/transaction_amount_grouped_data.dart';
import 'HomePage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const int _pageIndex = 2;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      Provider.of<TransactionProvider>(context, listen: false).getLastMostExpensiveTransactions();
      Provider.of<TransactionProvider>(context, listen: false).getTotalMonthAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: appProvider.transactions.isEmpty
        ? Center(child: Text(AppLocalizations.of(context)!.noDataForDashboard))
        : FutureBuilder(
        future:
            Provider.of<TransactionProvider>(context).getMaxAmountPerMonth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (appProvider.transactions.isEmpty) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.no_entry),
                TextButton(
                  onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const HomePage(),)
                    )
                  },
                  child: Text(AppLocalizations.of(context)!.home),
                ),
              ],
            ),);
          }
          List<MTransactionPerMonth> monthTransaction = appProvider.transactions_per_month;
          double lastTransactionAmount = appProvider.maxAmountPerMonth.last.periodAmount;
          double secondLastTransactionAmount = 0;
          double amountDifference = lastTransactionAmount;
          bool badMonth = false;
          bool onlyOneMonth = false;
          int percentage = 100; // default 100%

          if (appProvider.transactions.length > 1) {
            secondLastTransactionAmount = appProvider.maxAmountPerMonth[appProvider.maxAmountPerMonth.length-2].periodAmount;

            // more expenses than the second past month: bad month = no money saved
            badMonth = lastTransactionAmount > secondLastTransactionAmount;
            amountDifference = badMonth
                ? amountDifference - secondLastTransactionAmount
                : secondLastTransactionAmount - amountDifference;
                percentage = (lastTransactionAmount * 100/(lastTransactionAmount + secondLastTransactionAmount)).round();
          } else {
            onlyOneMonth = true;
          }

          return CustomScrollView(
            slivers: <Widget> [
              SliverAppBar(
                expandedHeight: 130,
                snap: true,
                floating: true,
                stretch: true,
                backgroundColor: Theme.of(context).colorScheme.background,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.total_month_spending,
                      style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Container(
                      height: 24,
                      width: 24,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: badMonth || onlyOneMonth ? Colors.red[600]!.withOpacity(0.2) : Colors.green[600]!.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Center(child: badMonth || onlyOneMonth
                        ? Icon(Icons.arrow_drop_up_outlined, color: Colors.red[700],)
                        : Icon(Icons.arrow_drop_down_outlined, color: Colors.green[700]),
                      )
                    ),
                    Text(
                      " $percentage %",
                      style: TextStyle(color: badMonth || onlyOneMonth ? Colors.red[700] : Colors.green[600]!.withOpacity(0.9), fontSize: 15),
                    )
                    
                  ],
                ),
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: Transform(
                    transform: Matrix4.translationValues(-50, 0, 0),
                    child: ListTile(
                      title: Text(
                        NumberFormat.currency(locale: 'de_DE', symbol: '€').format(appProvider.totalMonthAmount),
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  background: Container(color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SfCartesianChart(
                    series: _getSeries(appProvider),
                    primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat.MMM(appProvider.locale.countryCode),
                      intervalType: DateTimeIntervalType.months,
                      majorGridLines: const MajorGridLines(width: 0),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                    ),
                    primaryYAxis: NumericAxis(labelFormat: '{value}€'),
                    tooltipBehavior: TooltipBehavior(enable: true),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    AppLocalizations.of(context)!.month_most_expensive_transaction,
                    style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              SliverList(delegate: SliverChildListDelegate(
                appProvider.lastMostExpensiveTransactions.map((e) => 
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 10),
                          color: Theme.of(context).colorScheme.background,
                          elevation: 8,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                TransactionDetail.routeName,
                                arguments: Transaction(reason: e.reason, amount: e.amount, name: e.name, date: e.date, imagePath: e.imagePath, id: e.id)
                              );
                            },
                            child: ListTile(
                              title: Text(e.name, style: const TextStyle(fontWeight: FontWeight.w400),), 
                              subtitle: Text(DateFormat.MMMM(appProvider.locale.countryCode).format(DateTime.parse(e.date))),
                              trailing: Text(
                                NumberFormat.currency(locale: 'de_DE', symbol: '€').format(e.amount),
                                style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w500),),
                            ),
                          ),
                        ),
                      ),
                    ).toList()
              ),),
            ],
          );
        
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

  List<ColumnSeries<MTransactionGroupedAmountData, DateTime>> _getSeries(
      TransactionProvider provider) {
    return <ColumnSeries<MTransactionGroupedAmountData, DateTime>>[
      ColumnSeries<MTransactionGroupedAmountData, DateTime>(
        dataSource: provider.maxAmountPerMonth,
        name: AppLocalizations.of(context)!.expenses,
        xValueMapper: (MTransactionGroupedAmountData data, _) =>
            DateTime(DateTime.now().year, int.parse(data.periodDate)),
        yValueMapper: (MTransactionGroupedAmountData data, _) =>
            data.periodAmount,
        dataLabelSettings: const DataLabelSettings(isVisible: true, useSeriesColor: true),
        enableTooltip: true,
        markerSettings: const MarkerSettings(isVisible: true, shape: DataMarkerType.pentagon,),
        color: Theme.of(context).colorScheme.primary,
      ),
    ];
  }

  String _formatToCurrency(double number) {
    return NumberFormat.currency(locale: 'de_DE', symbol: '€')
        .format(number)
        .toString();
  }
}