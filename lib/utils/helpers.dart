import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Fn {
  Widget _transactionInputField(
      BuildContext context,
      TextEditingController controller,
      Widget prefixIcon,
      String hintText,
      TextInputType inputType, {
        int? maxLines,
      }
      ) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          prefixIcon: prefixIcon,
        ),
        keyboardType: inputType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.required_form_field_message;
          }
          return null;
        },
      ),
    );
  }
}

