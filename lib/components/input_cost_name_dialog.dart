import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:hikkoshi_cost_manager/model/repository/costs_repository.dart';

Future<void> inputCostNameDialog(
    BuildContext context, CostKind costKind, CostType type) async {
  final _formKey = GlobalKey<FormState>();
  return showDialog(
      context: context,
      builder: (context) {
        var costBudget = null;
        var costActual = null;
        var costName = null;
        String initialValue = "";
        final TextEditingController _costNameController =
        new TextEditingController(text: initialValue);
        final TextEditingController _costBudgetController =
        new TextEditingController(text: initialValue);
        final TextEditingController _costActualController =
        new TextEditingController(text: initialValue);
        return AlertDialog(
          title: Text("初期費用を追加"),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 250.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                  controller: _costNameController,
                  decoration: InputDecoration(
                    labelText: "費用名",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => _costNameController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                  ],
                  onChanged: (value) {
                    costName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '費用名を入力してください';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _costBudgetController,
                  decoration: InputDecoration(
                    labelText: "予算",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => _costBudgetController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(7),
                  ],
                  onChanged: (value) {
                    costBudget = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _costActualController,
                  decoration: InputDecoration(
                    labelText: "実際の費用",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => _costActualController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(7),
                  ],
                  onChanged: (value) {
                    costActual = value;
                  },
                ),
              ]),
            ),
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
                if (_formKey.currentState!.validate()) {
                  int? parsedBudgetCost = null;
                  int? parsedActualCost = null;
                  if (costBudget != null && costBudget != "") {
                    parsedBudgetCost = int.parse(costBudget!);
                    if (parsedBudgetCost == 0) {
                      parsedBudgetCost = null;
                    }
                  }
                  if (costActual != null && costActual != "") {
                    parsedActualCost = int.parse(costActual!);
                    if (parsedActualCost == 0) {
                      parsedActualCost = null;
                    }
                  }
                  CostRepository.create(
                      text: costName,
                      type: type.typeName,
                      budgetCost: parsedBudgetCost,
                      actualCost: parsedActualCost);
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ],
        );
      });
}
