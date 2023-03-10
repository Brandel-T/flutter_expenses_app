import 'package:expenses_app_2/models/transaction.dart';

class MData extends Transaction {
  late int calendarWeek; // Kanlendar Wochen

  MData({
    required super.id,
    required super.name,
    required super.reason,
    required super.amount,
    required super.imagePath,
    required super.date,
    required this.calendarWeek,
  });

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'reason': reason,
    'amount': amount,
    'imagePath': imagePath,
    'date': date,
    'calendarWeek': calendarWeek
  };

  @override
  fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    reason = data['reason'];
    amount = data['amount'];
    imagePath = data['imagePath'];
    date = data['date'];
    calendarWeek = data['calendarWeek'];
  }
}