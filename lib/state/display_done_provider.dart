import 'package:flutter/cupertino.dart';
import 'package:hikkoshi_cost_manager/components/date_formatter.dart';
import 'package:hooks_riverpod/all.dart';

final displayDoneProvider = ChangeNotifierProvider(
      (ref) => displayDoneSelector(),
);

class displayDoneSelector extends ChangeNotifier {
  var displayDoneFlg = false;

  void handleChange(bool newValue) {
    displayDoneFlg = newValue;
  }
}