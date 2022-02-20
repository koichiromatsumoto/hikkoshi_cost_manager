import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> selectDate(BuildContext context, {String? dateText = null}) async {
  final DateTime? selected = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2021),
    lastDate: DateTime(2023),
  );
  if (selected != null) {
    dateText = (DateFormat.yMMMd()).format(selected);
  }
  return dateText;
}