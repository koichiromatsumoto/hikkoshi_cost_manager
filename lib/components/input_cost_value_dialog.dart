import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:hikkoshi_cost_manager/model/repository/costs_repository.dart';

Future<void> inputCostValueDialog(
    BuildContext context, Cost cost, CostKind costKind) async {
  return showDialog(
      context: context,
      builder: (context) {
        var costStr = null;
        String initialValue = "";
        if (costKind == CostKind.budgetCost) {
          if (cost.budgetCost != null) {
            initialValue = cost.budgetCost.toString();
          }
        } else {
          if (cost.actualCost != null) {
            initialValue = cost.actualCost.toString();
          }
        }
        final TextEditingController _costValueController =
        new TextEditingController(text: initialValue);
        return AlertDialog(
          title: Text(cost.getName),
          content: TextFormField(
            controller: _costValueController,
            decoration: InputDecoration(
              labelText: costKind == CostKind.budgetCost ? "予算" : "実際の費用",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () => _costValueController.clear(),
                icon: Icon(Icons.clear),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(7),
            ],
            onChanged: (value) {
              costStr = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'キャンセル',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                if (costKind == CostKind.budgetCost) {
                  if (costStr != null && costStr != "") {
                    int parseCost = int.parse(costStr!);
                    if (parseCost != 0) {
                      CostRepository.budgetCostUpdate(
                          id: cost.id, budgetCost: parseCost);
                    } else {
                      CostRepository.budgetCostDelete(id: cost.id);
                    }
                  } else {
                    CostRepository.budgetCostDelete(id: cost.id);
                  }
                } else {
                  if (costStr != null && costStr != "") {
                    int parseCost = int.parse(costStr!);
                    if (parseCost != 0) {
                      CostRepository.actualCostUpdate(
                          id: cost.id, actualCost: parseCost);
                    } else {
                      CostRepository.actualCostDelete(id: cost.id);
                    }
                  } else {
                    CostRepository.actualCostDelete(id: cost.id);
                  }
                }
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ],
        );
      });
}