import 'package:flutter/material.dart';
import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:intl/intl.dart';

Text costText(Cost cost, CostKind costKind) {
  Text text;
  if (costKind == CostKind.budgetCost) {
    if (cost.budgetCost != null) {
      final formatter = NumberFormat("#,###");
      text = Text(
          formatter.format(cost.budgetCost).toString() + " 円",
          style: TextStyle(
              color: Colors.black87
          )
      );
    } else {
      text = Text(
          "なし",
          style: TextStyle(
              color: Colors.grey
          )
      );
    }
  } else {
    if (cost.actualCost != null) {
      final formatter = NumberFormat("#,###");
      text = Text(
          formatter.format(cost.actualCost).toString() + " 円",
          style: TextStyle(
              color: Colors.black87
          )
      );
    } else {
      text = Text(
          "なし",
          style: TextStyle(
              color: Colors.grey
          )
      );
    }
  }
  return text;
}