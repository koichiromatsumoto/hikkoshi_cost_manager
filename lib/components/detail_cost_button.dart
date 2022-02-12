import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:hikkoshi_cost_manager/screen/costs/detail_furniture_cost.dart';
import 'package:hikkoshi_cost_manager/screen/costs/detail_other_cost.dart';
import 'package:hikkoshi_cost_manager/screen/costs/detail_rent_cost.dart';

class DetailCostButton extends StatelessWidget {
  final String text;

  @override
  DetailCostButton(this.text);
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: deviceWidth * 0.8,
      height: 60,
      child: ElevatedButton(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Icon(
                  Icons.arrow_forward_ios
              ),
            ],
          ),
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<PageRoute<Widget>>(
            builder: (_) => returnPage(text)
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black87,
        ),
      ),
    );
  }
}

Widget returnPage(String text) {
  switch (text) {
    case "賃貸":
      return DetailRentCostPage(CostType.rent);
    case "家具家電":
      return DetailRentCostPage(CostType.furniture);
    case "その他":
      return DetailRentCostPage(CostType.other);
    default:
      return DetailRentCostPage(CostType.rent);
  }
}

Border flexBorder() {
  return Border.all(
    color: Colors.grey,
  );
}