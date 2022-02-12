import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:hikkoshi_cost_manager/model/repository/costs_repository.dart';

Future<void> costDeleteConfirmDialog(
    BuildContext context, Cost cost) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "${cost.getName}を削除してよろしいですか？"
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
                CostRepository.delete(cost.id);
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