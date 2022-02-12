import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hikkoshi_cost_manager/components/detail_cost_button.dart';
import 'package:hikkoshi_cost_manager/components/sum_cost.dart';
import 'package:hikkoshi_cost_manager/model/db/costs_database.dart';
import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:hikkoshi_cost_manager/model/repository/costs_repository.dart';
import 'package:hooks_riverpod/all.dart';

class CostManagePage extends StatefulWidget {

  @override
  _CostManagePageState createState() => new _CostManagePageState();
}

class _CostManagePageState extends State<CostManagePage> {

  @override
  // ignore: must_call_super
  void initState(){
    final CostsDatabase instance = CostsDatabase.instance;
    final db = instance.database;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    var futureBuilder = FutureBuilder(
      future: CostRepository.getAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return mainPageView(context, Cost.mainCache, false);
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              Cost.mainCache = snapshot.data;
              return mainPageView(context, Cost.mainCache, true);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("引越しの初期費用管理"),
        centerTitle: true,
      ),
      body: futureBuilder,
    );
  }

  Widget mainPageView(BuildContext context, List<Cost> costs, bool isEnabled) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final formatter = NumberFormat("#,###");
    int sumBudget = sumCost(costs, CostKind.budgetCost);
    int sumActual = sumCost(costs, CostKind.actualCost);
    String sumBudgetStr = formatter.format(sumBudget).toString();
    String sumActualStr = formatter.format(sumActual).toString();
    int calculatedCost = sumBudget - sumActual;
    String calculatedCostStr = calculatedCost >= 0 ? formatter.format(calculatedCost).toString() : formatter.format(calculatedCost.abs()).toString();
    return Container(
      color: Color.fromRGBO(220, 220, 220, 1.0),
      child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 50),
          child: Consumer(
              builder: (context, watch, child){
                return Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(40, 30, 30, 15),
                      child: Text(
                        "引越しにかかる初期費用を\n管理しましょう",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Column(
                            children: <Widget>[
                              DetailCostButton("賃貸"),
                              DetailCostButton("家具家電"),
                              DetailCostButton("その他"),
                            ]
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(40, 50, 30, 0),
                      child: Text(
                        "合計",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: deviceWidth * 0.8,
                      padding: EdgeInsets.fromLTRB(40, 20, 30, 15),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                child: Text("予算",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87)),
                              ),
                              Align(
                                child: Text(
                                    sumBudgetStr != "0" ? "$sumBudgetStr 円" : "なし",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                child: Text("実際の費用",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87)),
                              ),
                              Align(
                                child: Text(
                                    sumActualStr != "0" ? "$sumActualStr 円" : "なし",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87)),
                              ),
                            ],
                          ),
                          Divider(
                              color: Colors.black
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                (sumBudgetStr == "0" && sumActualStr == "0") ? "" : (calculatedCost >= 0 ? "$calculatedCostStr 円" : "-  $calculatedCostStr 円"),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: calculatedCost >= 0 ? Colors.black87 : Colors.redAccent)
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('Button'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        CostsDatabase.instance.destroyDatabase();
                      },
                    ),
                  ],
                );
              }
          )
      ),
    );
  }
}