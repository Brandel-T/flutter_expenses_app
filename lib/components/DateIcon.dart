import 'package:expenses_app_2/store/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateIcon extends StatelessWidget {
  final String date;

  const DateIcon({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<TransactionProvider>(context, listen: false);

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 7),
          child: Text(
            date,
            style: TextStyle(
              color: appProvider.isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        Image.asset(
          appProvider.isDark
              ? "assets/icons/icon-date-light.png"
              : "assets/icons/icon-date-dark.png",
          width: 30,
          height: 30,
        )
      ],
    );
  }
}
