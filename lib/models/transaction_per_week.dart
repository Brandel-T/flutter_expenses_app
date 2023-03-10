class MTransactionPerWeek {
  int calendarWeek;
  List<Map<String, dynamic>> weekTransactions;
  double totalAmount;
  String startWeekDay;

   MTransactionPerWeek({
     required this.calendarWeek,
     required this.weekTransactions,
     required this.totalAmount,
     required this.startWeekDay,
   });

   @override
  String toString() {
    return "{calendarWeek: $calendarWeek, totalAmount: $totalAmount, startWeekDay: $startWeekDay, weekTransactions: $weekTransactions}";
   }
}