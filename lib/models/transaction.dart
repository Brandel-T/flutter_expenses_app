class Transaction {
  String id;
  String name;
  String reason;
  double amount;
  String imagePath;
  String date;

  Transaction({
    required this.id,
    required this.name,
    required this.reason,
    required this.amount,
    required this.imagePath,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'reason': reason,
    'amount': amount,
    'imagePath': imagePath,
    'date': date
  };

  fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    reason = data['reason'];
    amount = data['amount'];
    imagePath = data['imagePath'];
    date = data['date'];
  }

  @override
  String toString() {
    return '{id: $id, name: $name, reason: $reason, amount: $amount, imagePath: $imagePath, date: $date}';
  }
}