class MTransactionGroupedAmountData extends Comparable {
  String periodDate;
  double periodAmount;

  MTransactionGroupedAmountData({
    required this.periodDate,
    required this.periodAmount,
  });

  @override
  String toString() {
    return "{periodDate: $periodDate, periodAmount: $periodAmount}";
  }

  @override
  int compareTo(other) {
    return periodDate.compareTo(other.periodDate);
  }
}