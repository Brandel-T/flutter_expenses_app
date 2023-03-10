class MTransactionPerYear {
  int calendarYear;
  List<Map<String, dynamic>> yearTransactions;
  double totalAmount;
  String year;

   MTransactionPerYear({
     required this.calendarYear,
     required this.yearTransactions,
     required this.totalAmount,
     required this.year,
   });

   @override
  String toString() {
    return "{calendarYear: $calendarYear, totalAmount: $totalAmount, startMonthDay: $year, MonthTransactions: $yearTransactions}";
   }
}