class MTransactionPerMonth {
  int calendarMonth;
  List<Map<String, dynamic>> monthTransactions;
  double totalAmount;
  String startMonthDay;

   MTransactionPerMonth({
     required this.calendarMonth,
     required this.monthTransactions,
     required this.totalAmount,
     required this.startMonthDay,
   });

   @override
  String toString() {
    return "{calendarMonth: $calendarMonth, totalAmount: $totalAmount, startMonthDay: $startMonthDay, MonthTransactions: $monthTransactions}";
   }
}